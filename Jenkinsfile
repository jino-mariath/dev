#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

stage ('BEHAT site Deployment') {
	   echo 'Executing Behat and Test & Stage site deployment in parallel. '
	 
	   parallel ('PAS_Site': {
		echo 'Initaing Behat sites code deployment. and checking if Behat / Behat site DB refresh job is in progress....'
		sh 'while : ; do BUILD_STATUS=`curl -s http://lxpc1283.cruises.princess.com:8080/job/$JOB_NAME/lastBuild/api/json -u pc08300:7f2156584a2d62302f8d0db7ffc85ab6 | grep -Po '"building":.*?"' | awk -F":" '{print $2}' | tr -d ",\""`;  [[ $BUILD_STATUS == true ]] || break ; done

		echo 'Behat jobs is not in execution / completed.'
 		echo 'Behat sites db refresh jobs is not in execution / completed.'
		build 'PAS_Behat_Site-Deployment'
	 	echo 'Behat site deployment completed. ' 
		},
		 
			PAS_BEHAT: {
		echo 'Executing Behat'
		sleep 5
		//sh 'sh /approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_Behat_Site-Deployment'
		sh 'sh /approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_Behat_db'
		build 'PAS_BEHAT'

              },

			PAS_Behat_db: {
		echo 'Executing PAS_Behat_db '
		sleep 5
		//sh 'sh /approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_Behat_Site-Deployment'
		sh 'sh /approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_BEHAT'
		build 'PAS_Behat_db'
              },
	   )
	}
