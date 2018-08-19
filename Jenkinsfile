#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

node ('master') {
    try {
	stage ('Test Gate') {
	   echo 'Initating P@S Test and P@S Stage site code deployment..'

	   parallel ('PAS_Dev_Language': {
		echo 'Executing DEV site language code.'
		//Get the Approvale if this part is failing --> http://lxpc1283.cruises.princess.com:8080/scriptApproval/

		String content = 'ssh WebTeam@lxpc1040 "/home/WebTeam/deployment/pas_dev_language.sh"'
                def myFile = new File('/approot/jenkins/jobs/PAS_Build_Script/workspace/dev_language.sh')
                myFile.write(content)

		sh 'chmod 755 /approot/jenkins/jobs/PAS_Build_Script/workspace/dev_language.sh'
		build(job: 'PAS_Build_Script', wait:false)
		//sh 'sh /approot/JenkinsFile-Project/deployment/pas_jenkins_build_scrips.sh dev_language.sh'
		echo 'For more details for this job please navigate to --> http://lxpc1283.cruises.princess.com:8080/job/PAS_Build_Script/default/lastBuild/console'
		},

		job('PA11y_Test') {
		   echo 'Executing ADA Test - PA11Y script'
                   blockOn(['PAS_Dev_Language', 'Sonar_Build_Status']) {
                      blockLevel('GLOBAL')
                      scanQueueFor('ALL')
                   }    
                }
        
		build 'PAS_TEST_PA11Y'
		},

			Sonar_Build_Status: {
		echo 'Checking Sonar Build status.... and Waiting for job to complete. --> http://lxpc1283.cruises.princess.com:8080/job/PAS_SONAR_TEST/lastBuild/console'
	        def SonarBuildStatus = sh(script: '/approot/JenkinsFile-Project/deployment/pas_build_status.sh PAS_SONAR_TEST', returnStdout: true)
		println SonarBuildStatus
                if(SonarBuildStatus.trim() == "SUCCESS") {
			println ("PAS_SONAR_TEST Status: SUCCESS,...")
			} else {
			println ("PAS_SONAR_TEST Failed Status, please check the job.")
			build.doStop();
			//currentBuild.result = 'FAILURE'
			}
		}		
	   )
	}
	
	stage ('BEHAT site Deployment') {
	   echo 'Executing Behat and Test & Stage site deployment in parallel. '
	 
	   parallel ('PAS_Behat': {
		echo 'Initaing Behat sites code deployment.'
		build 'PAS_Behat_Site-Deployment'
		},
		 
			PAS_TEST_Deploy: {
		echo 'Copying P@S package to Test Site'
		echo 'Copying Deployment files...'
		sh 'cd /approot/JenkinsFile-Project/deployment; rsync -avz ../deployment WebTeam@lxpc1041:/home/WebTeam/'
		//sh 'ssh WebTeam@lxpc1041 "cd /home/WebTeam/deployment/; sh deployment.sh &"'
		echo 'P@S code deployed to Test site Successfully...'
              },

			PAS_STAGE_Deploy: {
		echo 'Copying P@S package to Stage Site'
		echo 'Copying Deployment files...'
		sh 'cd /approot/JenkinsFile-Project/deployment;rsync -avz ../deployment WebTeam@lxpc1042:/home/WebTeam/'
		//sh 'ssh WebTeam@lxpc1042 "cd /home/WebTeam/deployment/; sh deployment.sh &"'
		echo 'P@S code deployed to Stage site Successfully...'
              },
	   )
	}

	stage ('Behat Smoke Test') {
	   echo 'Checking behat site status'
	   build 'PAS_SMOKE_TEST_behat'
	}


	stage ('Behat and Test site Execution') {
	   echo 'Test Site deployment and Iniating Behat job Execution'

	   parallel ('Behat_Execution': {
		echo 'Starting Behat ...'
		build 'PAS_BEHAT'
		},

			PAS_Test_Ship_Deploy: {
		echo 'Executing Test Ship site deployment'
		build 'PAS_TEST_SHIP'
		}
	   )
	}


    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Execution Completed Successfully......!'
}
