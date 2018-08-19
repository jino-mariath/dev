#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

stage ('BEHAT site Deployment') {
	   echo 'Executing Behat and Test & Stage site deployment in parallel. '
	 
	   parallel ('PAS_Site': {
		echo 'Initaing Behat sites code deployment. and checking if Behat / Behat site DB refresh job is in progress....'
		sh '/approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_BEHAT'
		echo 'Behat jobs is not in execution / completed.'
		sh '/approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_Behat_db'
 		echo 'Behat sites db refresh jobs is not in execution / completed.'
		build 'PAS_Behat_Site-Deployment'
	 	echo 'Behat site deployment completed. ' 
		},
		 
			PAS_BEHAT: {
		echo 'Executing Behat'
		sleep 5
		sh '/approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_Behat_Site-Deployment'
		sh '/approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_Behat_db'
		build 'PAS_BEHAT'

              },

			PAS_Behat_db: {
		echo 'Executing PAS_Behat_db '
		sleep 5
		sh '/approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_Behat_Site-Deployment'
		sh '/approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_BEHAT'
		build 'PAS_Behat_db'
              },
	   )
	}
