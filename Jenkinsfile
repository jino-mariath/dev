#!/usr/bin/env groovy

node ('master') {
    try {
        stage ('Dev Build') {
        echo 'Dev Build - 1. Git Pull'
        //build 'PAS_DEV'
        //sh 'pas_build.sh'
	sh 'sh test.sh'
        sh "pwd"
        }
    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Hello World'
}
