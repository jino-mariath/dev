#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

node ('master') {
    try {
        stage ('Dev Build') {
           echo 'Dev Build - 1. Git Pull'
	   echo 'For more details for this job please navigate to --> http://lxpc1283.cruises.princess.com:8080/job/PAS_DEV/lastBuild/console'
	   build 'Test'
	}
	

    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Execution Completed Successfully......!'
}
