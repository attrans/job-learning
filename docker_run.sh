#!/bin/sh

DIRNAME=`dirname $0`
RUNHOME=`cd $DIRNAME/; pwd`
echo @RUNHOME@ $RUNHOME


mkdir -p /home/zenap/ume-log/nia-qualcommon-service-ms

if [ -f "/home/dexcloud/initGlobalEnv.sh" ]; then
    . "/home/dexcloud/initGlobalEnv.sh"
else
    echo "can not found /home/dexcloud/initGlobalEnv.sh"
fi

if [ -f "$RUNHOME/setenv.sh" ]; then
    . "$RUNHOME/setenv.sh"
else
    echo "can not found $RUNHOME/setenv.sh"
fi

echo ================== ENV_INFO  =============================================
echo @RUNHOME@  $RUNHOME
echo @JAVA_BASE@  $JAVA_BASE
echo @Main_Class@  $Main_Class
echo @APP_INFO@  $APP_INFO
echo @Main_JAR@  $Main_JAR
echo @Main_Conf@ $Main_Conf
echo ==========================================================================

#if [ ! -d "./push-menu-nii.log"]; then
#  touch ./push-menu-nii.log
#fi
##chmod 755 ./push-menu-nii.log ./push-menu-nii.sh
#setsid sh push-menu-nii.sh > push-menu-nii.log

echo start $APP_INFO ...

JAVA="$JAVA_HOME/bin/java"
JAVA_OPTS="-Dconfdir=config -Xms$MIN_DUMP_SIZE -Xmx$MAX_DUMP_SIZE $JAVA_GLOBAL_OPTS $JVM_GC_OPTS"

CLASS_PATH="$EXT_DIRS:$RUNHOME/lib/*:$RUNHOME/:$RUNHOME/$Main_JAR"

echo ================== RUN_INFO  =============================================
echo @JAVA_HOME@ $JAVA_HOME
echo @JAVA@ $JAVA
echo @JAVA_OPTS@ $JAVA_OPTS
echo @CLASS_PATH@ $CLASS_PATH
echo ==========================================================================

echo @JAVA@ $JAVA
echo @JAVA_CMD@

"$JAVA" $JAVA_OPTS -classpath "$CLASS_PATH" $Main_Class
