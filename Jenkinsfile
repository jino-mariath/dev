#!/usr/bin/env groovy

node ('master') {
    try {
        stage ('Dev Build') {
           echo 'Dev Build - 1. Git Pull'
           build 'PAS_DEV'
	}
	stage ('P@S package copy') {
	   echo 'Copying files'
           parallel ('PAS_Dev_deploy': {
              build 'PAS_DEV'
              sh "sleep 10; pwd"
	      },
	        PAS_Sonar_Deploy: {
		   //build job: 'PAS_Dev_Deploy'
                   echo "deploying to P@S to Dev site.... "
		   sh 'sleep 10; ls -lah; pwd'
		},
                Pas_Dev_smoke_test:{
		   echo "P@S smote test .. make sure site is up and running after Deployment...."
		   sh 'sleep 15; pwd'
		}
	   ) 
        }  
    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Hello World'
}
