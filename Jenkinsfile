#!/usr/bin/env groovy

node ('master') {
    try {
        stage ('Dev Build') {
           echo 'Dev Build - 1. Git Pull'
	   //build 'PAS_DEV'
	}
	
	stage ('P@S Packaging') {
	   echo 'Initiating build script.'
	   echo 'Building package - Combining and Compressing P@S code ....'
	   //sh '/approot/JenkinsFile-Project/build/pas_build.sh'
 	   sh 'ls -lah /approot/jenkins/jobs/PAS_DEV/workspace/'
	}
	
        stage ('Artifactory') {
           echo 'Copying P@S package to Artifactory'
           sh '/approot/JenkinsFile-Project/build/pas-artifactory.sh'
        }

	parallel ('PAS_Dev_deploy': {
              echo 'Copying P@S package to Dev Site'
              sh 'rsync -avz /approot/jenkins/jobs/PAS_DEV/workspace/princessatsea* WebTeam@lxpc1042:/home/WebTeam/deployment/'
              echo 'Copying Deployment files...'
              sh 'cd /approot/JenkinsFile-Project/deployment; rsync -avz /approot/jenkins/jobs/PAS_DEV/var.properties .; rsync -avz ../deployment WebTeam@lxpc1042:/home/WebTeam/'
              sh 'ssh WebTeam@lxpc1042; cd /home/WebTeam/deployment/; sh deployment.sh'
              echo 'P@S code deployed to Dev site Successfully...'
              },

                Sonar Test: {
              echo 'Executing Sonar Test - Static Code Analyzer... primcessatsea-PAS_VERSION'
              build 'PAS_SONAR_TEST'
              }
           )
        }

    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Hello World'
}
