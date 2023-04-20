#!/bin/bash

all_ume_pods=`kubectl get pod -n ranoss -o wide | awk 'NR>1{print $1}'`
if [ -z "$all_ume_pods" ]; then
  echo "no pod under ranoss"
  exit 0
fi

echo "begin to process"

for one_pod in ${all_ume_pods};do
   all_contains_in_one_pod=`kubectl get pods ${one_pod} -o jsonpath={.spec.containers[*].name} -n ranoss`
   
   for one_container_in_one_pod in ${all_contains_in_one_pod};do
     if [[ ! ${one_container_in_one_pod} =~ "ui" ]];then
       continue
     fi
     echo "processing container ${one_pod}:${one_container_in_one_pod}"
     all_main_js=`kubectl exec  ${one_pod} -c ${one_container_in_one_pod} -n ranoss -- find /usr/share/nginx -name *.js 2>/dev/null | grep -E '[0-9a-zA-Z]{20}'| grep -E '\/[0-9]|\/main' |tr '\n' ' '`
	 if [[ ${all_main_js} ]];then
           #echo "all js:${all_main_js}"
           #echo "begin to replace content in ${one_main_js} under container ${one_container_in_one_pod}"
           kubectl exec  ${one_pod} -c ${one_container_in_one_pod} -n ranoss -- sed -i 's/this.query_subnet_url+"\&operation="+e+"\&name="+t:this.query_subnet_url+"\&name="+t/this.query_subnet_url+"\&operation="+e+"\&nbiId="+t:this.query_subnet_url+"\&nbiId="+t/g' ${all_main_js}
           #echo "end to replace content in ${one_main_js} under container ${one_container_in_one_pod}"
	 fi
   done
   
done

echo "end to process"
