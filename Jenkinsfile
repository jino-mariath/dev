#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

node ('master') {
    try {
        stage ('Dev Build') {
           echo 'Dev Build - 1. Git Pull'
	   echo 'For more details for this job please navigate to --> http://lxpc1283.cruises.princess.com:8080/job/PAS_DEV/lastBuild/console'
	   def SonarBuildStatus = sh(script: '/approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_SONAR_TEST', returnStdout: true)
           println SonarBuildStatus
	   echo 'Sonar status Define variable'
//	   def Sonar
	   Sonar = "SUCCESS"
	   println Sonar
	   echo 'Status'
//           if(SonarBuildStatus != SUCCESS) {
//               println ("PAS_SONAR_TEST Status: SUCCESS,...")
//               } else {
//               println ("PAS_SONAR_TEST Failed Status, please check the job.")
//               build.doStop();
//               //currentBuild.result = 'FAILURE'
//               }
	}
	

    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Execution Completed Successfully......!'
}
