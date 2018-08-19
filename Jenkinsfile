#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

stage ('BEHAT site Deployment') {
	   echo 'Executing Behat and Test & Stage site deployment in parallel. '
	 
	   parallel ('PAS_Behat': {
		echo 'Initaing Behat sites code deployment.'
		//build 'PAS_Behat_Site-Deployment
		//lock('PAS_STAGE_Deploy'){
		Jenkins.instance.getItem("PAS_STAGE_Deploy").disable()
	 	   echo "locked build- PAS_STAGE_Deploy" 
		},
		 
			PAS_TEST_Deploy: {
		echo 'Copying P@S package to Test Site'
		echo 'Copying Deployment files...'
		//sh 'cd /approot/JenkinsFile-Project/deployment; rsync -avz ../deployment WebTeam@lxpc1041:/home/WebTeam/'
		//sh 'ssh WebTeam@lxpc1041 "cd /home/WebTeam/deployment/; sh deployment.sh &"'
		echo 'P@S code deployed to Test site Successfully...'
              },

			PAS_STAGE_Deploy: {
		echo 'Copying P@S package to Stage Site'
		echo 'Copying Deployment files...'
		//sh 'cd /approot/JenkinsFile-Project/deployment;rsync -avz ../deployment WebTeam@lxpc1042:/home/WebTeam/'
		//sh 'ssh WebTeam@lxpc1042 "cd /home/WebTeam/deployment/; sh deployment.sh &"'
		echo 'P@S code deployed to Stage site Successfully...'
              },
	   )
	}
