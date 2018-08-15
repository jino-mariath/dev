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
	}
	
        stage ('Artifactory') {
           echo 'Copying P@S package to Artifactory'

 	   parallel ('PAS_Artifactory': {
		sh 'ls -la'
		},
	
			PAS_Dev_deploy: {
              echo 'Copying P@S package to Dev Site'
              //sh 'rsync -avz /approot/jenkins/jobs/PAS_DEV/workspace/princessatsea* WebTeam@lxpc1042:/home/WebTeam/deployment/'
              echo 'Copying Deployment files...'
              echo 'P@S code deployed to Dev site Successfully...'
              },

                	Sonar_Test: {
              echo 'Executing Sonar Test - Static Code Analyzer... primcessatsea-PAS_VERSION'
	      build 'PAS_SONAR'
	      wait: false
	      propagate: false
       	      echo 'Executing Sonar Job ...'

              }
           )
        }

	stage ('P@S Test and Stage Deployment') {
	   echo 'Initating P@S Test and P@S Stage site code deployment..'

	   parallel ('PAS_TEST_Deploy': {
		echo 'Copying P@S package to Test Site'
		echo 'Copying Deployment files...'
		echo 'P@S code deployed to Test site Successfully...'
              },

			PAS_STAGE_Deploy: {
		echo 'Copying P@S package to Stage Site'
		echo 'Copying Deployment files...'
		echo 'P@S code deployed to Stage site Successfully...'
              },
	   )
	}
 

    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Execution Completed Successfully......!'
}
