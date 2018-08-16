#!/bin/bash

JOB_NAME=$1

BUILD_SUCCESS=`ls -lt /var/lib/jenkins/jobs/$JOB_NAME/build/ | grep -i lastSuccessfulBuild | awk -F"->" '{print $2}'`
BUILD_UNSUCCESS=`ls -lt /var/lib/jenkins/jobs/$JOB_NAME/build/ | grep -i lastUnsuccessfulBuild | awk -F"->" '{print $2}'`

if [ $BUILD_SUCCESS -gt $BUILD_UNSUCCESS ]
   then 
     echo "Jenkins Job - $JOB_NAME - status is Passed. "  
     BUILD=`expr $BUILD_SUCCESS - 0`
   else
     echo " Jenkins Job - $JOB_NAME - status is Failed.. "
     BUILD=`expr $BUILD_UNSUCCESS - 0`
    # exit
fi

echo $BUILD


STATUS=`tail /var/lib/jenkins/jobs/$JOB_NAME/build/$BUILD/log | grep -i Finished | awk '{ print $2}'`

echo $STATUS

if [ $STATUS == 'SUCCESS' ]
then
  echo "The last Build of Job - $JOB_NAME is Successful."
else
  echo "The last Build of Job - $JOB_NAME is Failure / Unstable."
fi
