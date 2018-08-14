#!/usr/bin/env groovy

node ('master') {
    try {
        stage ('Dev Build') {
           echo 'Dev Build - 1. Git Pull'
           build 'PAS_DEV'
	}
    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Hello World'
}
