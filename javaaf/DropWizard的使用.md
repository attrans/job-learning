
转至元数据结尾
由 胡锐10071214创建, 最终由 杜永林10232509修改于 八月 29, 2018 转至元数据起始
步骤1：引入pom
步骤2：创建配置类
步骤3：创建Application类 
步骤4：创建表现层的类
步骤5：创建资源（Resource）类
步骤6：将资源类注册到Dropwizard中
步骤7：创建用于程序运行状态检查的功能（Health Check）
步骤8：将状态检查的功能注册到Dropwizard中
步骤9：运行Dropwizard程序


在这里，将一步一步的介绍使用dropwizard框架如何开发一个简单的restful微服务，步骤如下：

步骤1：引入pom


在maven的pom文件中，增加对dropwizard库的依赖（目前，支持的dropwizard版本是1.3.1）,添加后的pom内容如下：



<dependencies>
    <dependency>
        <groupId>io.dropwizard</groupId>
        <artifactId>dropwizard-core</artifactId>
        <version>${dropwizard.version}</version> <!-- dropwizard.version已经在顶层POM中进行了定义，可以直接使用或者不声明version，通过继承来获取 -->
    </dependency>
</dependencies>
步骤2：创建配置类
定义应用程序都有它自己的dropwizard配置类。

这个配置类继承于dropwizard的Configuration，指定环境的具体参数。这些参数在一个YAML配置文件反序列化到应用程序的配置类和验证实例指定。

package com.example.helloworld;
  
import io.dropwizard.Configuration;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.hibernate.validator.constraints.NotEmpty;
  
public class HelloWorldConfiguration extends Configuration {
    @NotEmpty
    private String template;
  
    @NotEmpty
    private String defaultName = "Stranger";
  
    @JsonProperty
    public String getTemplate() {
        return template;
    }
  
    @JsonProperty
    public void setTemplate(String template) {
        this.template = template;
    }
  
    @JsonProperty
    public String getDefaultName() {
        return defaultName;
    }
  
    @JsonProperty
    public void setDefaultName(String name) {
        this.defaultName = name;
    }
}
步骤3：创建Application类 
结合配置的Configuration类， Application 类是dropwizard应用的核心。Application将其提供基本功能的各种包和命令结合起来。以HelloWorldApplication为例，如下：

package com.example.helloworld;
  
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import com.example.helloworld.resources.HelloWorldResource;
import com.example.helloworld.health.TemplateHealthCheck;
  
public class HelloWorldApplication extends Application<HelloWorldConfiguration> {
    public static void main(String[] args) throws Exception {
        new HelloWorldApplication().run(args);
    }
  
    @Override
    public String getName() {
        return "hello-world";
    }
  
    @Override
    public void initialize(Bootstrap<HelloWorldConfiguration> bootstrap) {
        // nothing to do yet
    }
  
    @Override
    public void run(HelloWorldConfiguration configuration, Environment environment) {
    // nothing to do yet
    }
}
HelloWorldApplication通过参数化的形式引用到了HelloWorldConfiguration对象，在HelloWorldApplication中initialize方法，会在业务逻辑运行之前，需要配置方面的应用程序运行，如相关模块，数据源等，而main方法是整个程序的入口点。

注意此处目的是

步骤4：创建表现层的类
Dropwizrad在表现层方面使用jersey框架，采用json作为交互方法，因此，表现层的类的形式如下：

package com.example.helloworld.api; 

import com.fasterxml.jackson.annotation.JsonProperty; 
import org.hibernate.validator.constraints.Length; 

public class Saying { 
private long id; 

@Length(max = 3) 
private String content; 

public Saying() { 
// Jackson deserialization 
} 

public Saying(long id, String content) { 
this.id = id; 
this.content = content; 
} 

@JsonProperty 
public long getId() { 
return id; 
} 

@JsonProperty 
public String getContent() { 
return content; 
} 
}

步骤5：创建资源（Resource）类
在RESTFUL的架构设计中，相关的操作都是针对某些特定的资源展开的，在Dropwizard中，创建的资源类如下：

package com.example.helloworld.resources; 

import com.example.helloworld.api.Saying; 
import com.google.common.base.Optional; 
import com.codahale.metrics.annotation.Timed; 

import javax.ws.rs.GET; 
import javax.ws.rs.Path; 
import javax.ws.rs.Produces; 
import javax.ws.rs.QueryParam; 
import javax.ws.rs.core.MediaType; 
import java.util.concurrent.atomic.AtomicLong; 

@Path("/hello-world") 
@Produces(MediaType.APPLICATION_JSON) 
public class HelloWorldResource { 
private final String template; 
private final String defaultName; 
private final AtomicLong counter; 

public HelloWorldResource(String template, String defaultName) { 
this.template = template; 
this.defaultName = defaultName; 
this.counter = new AtomicLong(); 
} 

@GET 
@Timed 
public Saying sayHello(@QueryParam("name") Optional<String> name) { 
final String value = String.format(template, name.or(defaultName)); 
return new Saying(counter.incrementAndGet(), value); 
} 
}



步骤6：将资源类注册到Dropwizard中
如下的方法是在Application 类中完成

@Override 
public void run(HelloWorldConfiguration configuration, 
Environment environment) { 
final HelloWorldResource resource = new HelloWorldResource( 
configuration.getTemplate(), 
configuration.getDefaultName() 
); 
environment.jersey().register(resource); 
}



步骤7：创建用于程序运行状态检查的功能（Health Check）
package com.example.helloworld.health; 

import com.codahale.metrics.health.HealthCheck; 

public class TemplateHealthCheck extends HealthCheck { 
private final String template; 

public TemplateHealthCheck(String template) { 
this.template = template; 
} 

@Override 
protected Result check() throws Exception { 
final String saying = String.format(template, "TEST"); 
if (!saying.contains("TEST")) { 
return Result.unhealthy("template doesn't include a name"); 
} 
return Result.healthy(); 
} 
}



步骤8：将状态检查的功能注册到Dropwizard中
如下的方法是在Application 类中完成

@Override 
public void run(HelloWorldConfiguration configuration, 
Environment environment) { 
final HelloWorldResource resource = new HelloWorldResource( 
configuration.getTemplate(), 
configuration.getDefaultName() 
); 
final TemplateHealthCheck healthCheck = 
new TemplateHealthCheck(configuration.getTemplate()); 
environment.healthChecks().register("template", healthCheck); 
environment.jersey().register(resource); 
}

步骤9：运行Dropwizard程序
将上面的编写的程序，通过maven打包成一个jar文件，就可以使用如下的命令执行

java -jar target/hello-world-0.0.1-SNAPSHOT.jar server hello-world.yml


参考资料：http://www.dropwizard.io/0.9.2/docs/getting-started.html
