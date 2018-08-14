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
	
    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Hello World'
}
