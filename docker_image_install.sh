#!/bin/bash
set -e

dir_name=`dirname $0`
work_dir=`cd $dir_name/; pwd`
zart_cli=/root/zartcli/zartcli

emapp_oid=$1

log_file=install-$emapp_oid.log
log_path=$LOG_DIRECTORY

tenant_id=ranoss
emapp_ver=V18.21.30.03.n026

# ============================================================================
# log log_text
# ============================================================================
function log(){
	if [ -z "$log_path" ]; then
		log_path=/var/log/$emapp_oid
	fi

	if [ ! -d $log_path ]; then
		mkdir -p $log_path
	fi

	local target=$log_path/$log_file
	if [ ! -f $target ]; then
		touch $target
	fi

	log_text="`date +%Y-%m-%d\ %T` [$emapp_oid] $1"

	echo "$log_text" >> $target
	echo "$log_text"
}

# ============================================================================
# create_docker_image image_name file_path
# ============================================================================
create_docker_image(){
	local image_name=$1
	local file_path=$work_dir/$2
	log "create docker image $image_name..."
	$zart_cli -o delete -m image -i $tenant_id -n $image_name -v $emapp_ver || true >/dev/null
	$zart_cli -o build -m image -i $tenant_id -n $image_name -v $emapp_ver -p $file_path -b yes
}

# ============================================================================
# create_mi_blueprint microservice_name file_path
# ============================================================================
create_mi_blueprint() {
	local microservice_name=$1
	local file_path=$work_dir/$2
	log "create microservice buleprint $microservice_name..."
	$zart_cli -o delete -m bp -t microservice -i $tenant_id -n $microservice_name -v $emapp_ver || true >/dev/null
	$zart_cli -o upload -m bp -t microservice -i $tenant_id -n $microservice_name -v $emapp_ver -p $file_path
}

# ============================================================================
# create_se_blueprint service_name file_path
# ============================================================================
create_se_blueprint() {
	local service_name=$1
	local file_path=$work_dir/$2
	log "create service buleprint $service_name..."
	$zart_cli -o delete -m bp -t service -i $tenant_id -n $service_name -v $emapp_ver || true >/dev/null
	$zart_cli -o upload -m bp -t service -i $tenant_id -n $service_name -v $emapp_ver -p $file_path -b yes
}

# ============================================================================
# check_docker_image image_name
# ============================================================================
check_docker_image() {
	local image_name=$1
	local image_stat=""

	for i in {1..60}
	do
		image_stat=`$zart_cli -o query -i $tenant_id -m image -n $image_name -v $emapp_ver | grep "status" | awk '{print $2}'`
		image_stat=`echo $image_stat | sed 's/,$//g' | sed 's/^"//g' | sed 's/"$//g'`
		log "docker image status: $image_name $image_stat"
		if [ $image_stat = "available" ] || [ $image_stat = "unavailable" ];then
			break
		else
			sleep 5
		fi
	done

	if [ $image_stat != "available" ]; then
		log "failed to build docker image $image_name!"
		exit 1
	fi
}


# ============================================================================
# step 1: create
# ============================================================================
log "creating..."

create_docker_image "${emapp_oid}-sl" "${emapp_oid}-sl/"

# create_se_blueprint "${emapp_oid}" "blueprint/"

# ============================================================================
# step 2: check
# ============================================================================
log "checking..."

check_docker_image "${emapp_oid}-sl"


# ============================================================================
# end
# ============================================================================
log "install success!"
