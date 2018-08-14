#!/usr/bin/env groovy

node ('master') {
    try {
        stage ('Dev Build') {
           echo 'Dev Build - 1. Git Pull'
           build 'PAS_DEV'
	}
	
	stage ('P@S Packaging') {
	   echo 'Initiating build script.'
	   echo 'Building package - Combining and Compressing P@S code ....'
	   sh '/approot/JenkinsFile-Project/build/pas_build.sh'
 	   sh 'ls -lah /approot/jenkins/jobs/PAS_DEV/workspace/
	}
	
	stage ('Artifactory') {
	   echo 'Copying P@S package to Artifactory'
	   sh ' cd /approot/jenkins/jobs/PAS_DEV/workspace/ ; file=`ls -lah princessatsea-*.tar.gz | awk -F " " '{print $NF}'`; curl -v  --user admin:AP6x7VgHK4kkq57C -X PUT "http://artifactory.cruises.princess.com:8081/artifactory/Angular/$file" -T $file
	}
	   parallel ('PAS_Dev_deploy': {
	      echo 'Copying P@S package to Dev Site'
	      sh 'rsync -avz /approot/jenkins/jobs/PAS_DEV/workspace/princessatsea* WebTeam@lxpc1042:/home/WebTeam/deployment/'
	      echo 'Copying Deployment files...'
	      sh 'rsync -avz /approot/JenkinsFile-Project/deployment/deployment.php WebTeam@lxpc1042:/home/WebTeam/deployment/'
	      sh 'ssh WebTeam@lxpc1042; cd /home/WebTeam/deployment/; php deployment.php -s $file -d /home/WebTeam/PAS_TESTSITE/ -p 755' 
	      echo 'P@S code deployed to Dev site Successfully...'
	      },

		Sonar Test: {
	      echo 'Executing Sonar Test - Static Code Analyzer...'
	      build 'PAS_SONAR_TEST'
	      }
	)

    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Hello World'
}
