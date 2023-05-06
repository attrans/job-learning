1. 概要
    kafka是一款流行且强大的中间件，主要用于异步、解耦、流量削峰等。作为UME目前使用的消息队列，OTCP包装了kafka client的一些API，并提供了二次开发文档：kafka客户端。SA cop也提供了详尽的开发指南：1、Kafka使用规范

    本文的目的是简单介绍一下kafka的发布/订阅消息机制，以及针对已有的故障给出一些面向开发的api使用建议，做到快速上手。



2. 发布/订阅
    kafka的发布/订阅消息机制网上有很多资料可以查阅，比如：https://zhuanlan.zhihu.com/p/538311683。其中研发需要优先关注的元素有：broker、topic（主题）、partition（分区）、producer（生产者）、consumer（消费者）、offset（偏移位）、consumer group（消费者组）以及它的rebalance（重平衡）等。

    发布消息相对简单一点，订阅消息使用的consumer有一个group的概念需要注意：

producer发布的消息会放在服务器端topic的partition下，其中partition里的消息是有序的（可通过key-value控制），用（服务器端）offset标识。

topic、partition和producer



consumer必须得放在一个group里，同一个group中的consumer会消费不同的partition（无重复消费），不同的group之间消费的消息预期是一样的（重复消费）。

ps：引入group的概念可以做到消息广播和单点传播的切换：多个group（单consumer），就是简单的群发。单个group（多个consumer）就是点对点传输、支持并发。

consumer group


consumer和分区是1：n的关系，如果分区被分配完了，会存在空闲的consumer。consumer、partition发生改变时会触发相关消费组的rebalance。

consumer 1：n partition

空闲的consumer


offset有本地和服务端(committed offset)之分，有可能出现不一致的情况，这时候会依据配置的策略将offset统一，本地提交offset可以设置为手动。

auto.offset.reset
官方文档的解释是：“What to do when there is no initial offset in Kafka or if the current offset does not exist any more on the server (e.g. because that data has been deleted): <ul><li>earliest: automatically reset the offset to the earliest offset<li>latest: automatically reset the offset to the latest offset</li><li>none: throw exception to the consumer if no previous offset is found for the consumer\'s group</li><li>anything else: throw exception to the consumer.</li></ul>"

简单理解就是：

1.服务器端topic/partition如果没有committed offset（对应某个消费者组，新起的就是无），那么offset被同步成earliest（日志最老消息）or latest（日志最新消息的未来下一个）

2.客户端的offset和服务端的committed offset对不上（比如消费太慢了，服务器端消息被删了），那么offset被同步成earliest or latest



服务器会监听客户端consumer poll()的间隔，如果间隔超过max.poll.interval.ms(默认值5分钟)，会认为consumer已经失效，会触发rebalance。

consumer保活
心跳
poll间隔


UME创建topic后默认的partition数量是对应kafka实体replica数目*2，可以调用kafka的api或在自管理界面重新分配partition。

kafka服务


3. 故障相关
    收集了一些kafka相关的故障，主要包含以下几种场景，分别给出对应编码建议

3.1 创建consumer的时机
    应用中有种常见的场景：服务A调用服务B的API，然后监听上报的进度消息。消息是通知型的，非数据型，一个任务下来量也不会很大。此场景很多人会收到任务ID后，临时创建一个consumer，并放在一个新的分组里，监听完毕后再调用close()关闭。

临时consumer
----图中代码直接调用了consumer的构造函数，建议还是使用otcp包装的kafka接口创建consumer，otcp的防腐层做的还是有必要的：


----用完即关：


    但是这种方式有一个问题，通过观察多个环境的日志发现：consumer创建以及(re)joinning分组成功需要3秒，假如在这3秒内kafka服务器端的分区已经收到100%进度的消息了，那么客户端就不会消费它了，因为默认策略auto.offset.reset=latest，客户端的consumer初始化后（新consumer group）的offset取服务器端的最新值。

    ps：设置auto.offset.reset=earliest的话，就可能会出现重复消费的问题，而latest则会“丢失”消息，这其实就是一个权衡的问题。

    改造的建议是服务启动时创建consumer，至于几个consumer几个分组可以根据实际情况而定。以控制器直连最近的一个故障为例，原代码是如上所述起的临时consumer，对应一个临时分组。改进后是这样的：每个微服务启动时创建一个consumer，分组取一个固定的，即单分组多consumer。这样就会出现上面提到的一个情况：有些consumer没有对应partition。但是没关系，我们依着简单设计的思路，依靠Kafka consumer's group management functionality即可。然后，为了poll间隔时间不超过上限，将消息缓存在了pgcache里，消费线程执行完毕后删除缓存对应消息

全局consumer
----进程启动的时候创建consumer，不关闭。每个实例对应一个consumer，分组固定一个，poll的消息放入缓存，保证不会被服务器端认为失效




多线程消费常用策略
3.2 多个Kafka服务端实体
    UME部署的时候，如果规模增大，可能会出现多个kafka实体，此时代码层面的应对可能没对上，导致bug。具体可参考王飞的帖子：https://media-moa.zte.com.cn/mpp_fs/MsgView?msgId=e5afce666287bb962f2dcd02a2f6a92dac11e9684d76dcf6&_v=221

3.3 过量生产、消费不足
    生产者那边因为某些场景产能过剩、或者消费者消费能力不足，可导致消息挤压，消费滞后，甚至丢消息。一般常见的原因分为如下几种：

服务器端的消息存在时间超过log.retention.hours（默认168小时=7天）将会被删除。此时如果客户端consumer的offset仍然小于被删消息的offset（相当于消息在服务器端放了7天还未被消费。。），此时offset会按照参数auto.offset.reset重新设值并统一，不管是earliest（log文件中未删除消息中最早的）或者latest（最新的），都已经出现了消息“丢失”。

本地offset和远端offset对不上触发reset


某客户端消费较慢（外场遇到过一个异常场景：死锁），超过了poll的间隔限制max.poll.interval.ms，服务器端认为该consumer已失效，触发rebalance试图重新分配分区到consumer，但是很多时候应用代码那里就起了一个consumer，所以就没有可分配的了，造成消息“丢失”。

auto.offset.reset被设置成earliest，当新起消费组的时候，会重新消费partition里存储的所有消息。老消息对应的状态已经陈旧（比如文件没了），导致处理消息的线程失败。然后失败的策略是无限重试，导致“卡死“。

    针对生产者产能过剩，可以梳理一些信息剧增的场景、或者精简消息数量。针对消费能力不足，可以尝试以下策略：

控制poll间隔，将消息处理和消息接收拆分，一个线程接消息，一个线程处理消息

增加分区数目，分组内增加consumer。改进消费逻辑代码：过滤不需要的消息、优化或重组耗时的动作

ps：分区的数目理论上越多（理想是某组内consumer数量 1:1 分区数）吞吐量越大，但是同时也增加了系统的消耗。所以这个配置需要压力测试去调参，或者依UME的规模分级设置

kafka自管理界面分区重设
OTCP kafka client创建topic、配置分区API
假如现场offset乱掉了导致故障，可以使用kafka自管理或cmd命令重置对应partition & consumer group的committed offset

tool cmd


URL：https://cwiki.apache.org/confluence/display/KAFKA/KIP-122%3A+Add+Reset+Consumer+Group+Offsets+tooling


kafka自管理
先停掉consumer group 相关服务，红框按钮就可以点击了：

![Uploading image.png…]()





3.4 任务/线程相关控制（非kafka本身）
    使用kafka api过程中一般会牵涉到多线程并发或者阻塞等待，现列出最近出现的两单故障：

A服务异步调用B服务的api（上报用kafka），一次调用作为一个任务占用一个线程，里面新建一个消费者in新消费组。最后是因为线程数量超限了导致进程被kill。

producer发送消息的api选择了阻塞等待发送结果，此时线程被调用了interrupt()，这里抛出了意料外的InterruptedException导致报错信息不详

3.5 故障相关小结
    从收集的故障来看，典型的或受关注的都是“丢”消息和重复消费的问题，分析/解决方法上面都有提到。为了不至于外场运行时因kafka消息相关原因卡死业务流程，这里建议将topic-partition-group-consumer-location记下来（使用缓存或者DB），然后结合Reset Consumer Group Offsets Tool、甚至重启微服务来规避问题。 
