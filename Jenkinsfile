#!/usr/bin/env groovy

node ('master') {
    try {
        stage ('Dev Build') {
        echo 'Dev Build - 1. Git Pull'
        build 'PAS_DEV'
        sh 'sh pas_build.sh'
	sh 'sh test.sh'
        sh "pwd"
        }
	parallel ('PAS_Dev_Deploy': {
		//build job: 'PAS_Dev_Deploy'
		},
		   Pas_Dev_smoke_test:{
		   echo "Deploying P@S to Dev site...."
		   sh 'sh test.sh'
		   sh 'pwd'
		}
	)
    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Hello World'
}
