#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

node ('master') {
    try {
        stage ('Dev Build') {
           echo 'Dev Build - 1. Git Pull'
	   echo 'For more details for this job please navigate to --> http://lxpc1283.cruises.princess.com:8080/job/PAS_DEV/lastBuild/console'
	   build 'PAS_DEV'
	}
	
	stage ('P@S Packaging') {
	   echo 'Initiating build script.'
	   echo 'Building package - Combining and Compressing P@S code ....'
	   sh '/approot/JenkinsFile-Project/build/pas_build.sh'
 	   sh 'ls -lah /approot/jenkins/jobs/PAS_DEV/workspace/'
	   String pas_version = new File('/approot/jenkins/jobs/PAS_DEV/workspace/pas.version').text
	   String version = 'P@S package has been created with Version : ' + pas_version
	   echo version
	}
	
        stage ('Artifactory') {
           echo 'Copying P@S package to Artifactory'

 	   parallel ('PAS_Artifactory': {
		sh '/approot/JenkinsFile-Project/build/pas-artifactory.sh'
		},
	
			PAS_Dev_deploy: {
              echo 'Copying P@S package to Dev Site'
              echo 'Copying Deployment files...'
              sh 'cd /approot/JenkinsFile-Project/deployment; rsync -avz /approot/jenkins/jobs/PAS_DEV/var.properties .; rsync -avz ../deployment WebTeam@lxpc1040:/home/WebTeam/'
              sh 'ssh WebTeam@lxpc1040 "cd /home/WebTeam/deployment/; sh deployment.sh"'
              echo 'P@S code deployed to Dev site Successfully...'
	      sh '/approot/JenkinsFile-Project/scripts/Jenkins-DEV_Flag-Notification.sh'
              },

                	Sonar_Test: {
              echo 'Executing Sonar Test - Static Code Analyzer... princessatsea-PAS_VERSION, More details => http://lxpc1283.cruises.princess.com:8080/job/PAS_SONAR_TEST/lastBuild/console'
	      sh 'rsync -avz /approot/jenkins/jobs/PAS_DEV/workspace/pas.version /approot/jenkins/jobs/PAS_SONAR_TEST/'
	      String sonar_version = new File('/approot/jenkins/jobs/PAS_SONAR_TEST/pas.version').text
              String version = 'Iniating Static code analysis for P@S Version : ' + sonar_version
              echo version
              build(job: 'PAS_SONAR_TEST', wait:false)
              }
           )
        }
	
	stage ('DEV SmokeTest') {
	   echo 'Cheking DEV site status after deployment. '
	   sh 'sh /approot/jenkins/jobs/PAS_DEV/workspace/PAS/ci/shell_scripts/bin/pax_intranet_smoke_test.sh https://devprincessatsea.cruises.princess.com/'
	}

	stage ('Test Gate') {
	   echo 'Initating P@S Test and P@S Stage site code deployment..'

	   parallel ('PAS_Dev_Language': {
		echo 'Executing DEV site language code.'
		//Get the Approvale if this part is failing --> http://lxpc1283.cruises.princess.com:8080/scriptApproval/

		String content = 'ssh WebTeam@lxpc1040 "/home/WebTeam/deployment/pas_dev_language.sh"'
                def myFile = new File('/approot/jenkins/jobs/PAS_Build_Script/workspace/dev_language.sh')
                myFile.write(content)
		
		sh 'rsync -avz /approot/JenkinsFile-Project/deployment/pas_dev_language.sh WebTeam@lxpc1040:deployment/'
		echo 'For more details for this job please navigate to --> http://lxpc1283.cruises.princess.com:8080/job/PAS_Build_Script/default/lastBuild/console'
		build(job: 'PAS_Build_Script', wait:false)
		},

			Pa11y_Test: {
		sh 'rsync -avz /approot/jenkins/jobs/PAS_SONAR_TEST/pas.version /approot/jenkins/jobs/PAS_TEST_PA11Y/'
              	String pa11y_version = new File('/approot/jenkins/jobs/PAS_TEST_PA11Y/pas.version').text
              	String version = 'Iniating ADA Compliance code analysis for P@S Version : ' + pa11y_version
              	echo version
		echo 'Executing ADA Test - PA11Y script, for more details => http://lxpc1283.cruises.princess.com:8080/job/PAS_TEST_PA11Y/lastBuild/console'
		build 'PAS_TEST_PA11Y'
		},

			Sonar_Build_Status: {
		echo 'Checking Sonar Build status.... and Waiting for job to complete. --> http://lxpc1283.cruises.princess.com:8080/job/PAS_SONAR_TEST/lastBuild/console'
		sleep(10) //Sleep 10 Sec
	        def SonarBuildStatus = sh(script: '/approot/JenkinsFile-Project/scripts/pas_build_status.sh PAS_SONAR_TEST', returnStdout: true)
		println SonarBuildStatus
                if(SonarBuildStatus.trim() == "SUCCESS") {
			println ("PAS_SONAR_TEST Status: SUCCESS,...")
			} else {
			println ("PAS_SONAR_TEST Failed Status, please check the job.")
			build.doStop();
			//currentBuild.result = 'FAILURE'
			}
		sh '/approot/JenkinsFile-Project/scripts/Jenkins-DEV_Flag-Notification.sh'
		}
	   )
	}
	
	stage ('BEHAT site Deployment') {
	   echo 'Executing Behat and Test & Stage site deployment in parallel. '
	 
	   parallel ('PAS_Behat_Site-Deployment': {
		sh 'rsync -avz /approot/jenkins/jobs/PAS_TEST_PA11Y/pas.version /approot/jenkins/jobs/PAS_Behat_Site-Deployment/'
                String pas_behat_version = new File('/approot/jenkins/jobs/PAS_Behat_Site-Deployment/pas.version').text
                String version = 'Iniating Behat Sites deployment P@S Version : ' + pas_behat_version
                echo version
		echo 'Promote latest P@S version to Behat sites. For Console log => http://lxpc1283.cruises.princess.com:8080/job/PAS_Behat_Site-Deployment/lastBuild/console'
		build 'PAS_Behat_Site-Deployment'
		sh '/approot/JenkinsFile-Project/scripts/Jenkins-DEV_Flag-Notification.sh'
		},
		 
			PAS_TEST_Deploy: {
		sh 'rsync -avz /approot/jenkins/jobs/PAS_TEST_PA11Y/pas.version /approot/jenkins/jobs/PAS_TEST_Deploy/'
                String pas_test_version = new File('/approot/jenkins/jobs/PAS_TEST_Deploy/pas.version').text
                String version = 'Deploying P@S code to Test P@S Site - PAS Version : ' + pas_test_version
                echo version
		sh 'cd /approot/JenkinsFile-Project/deployment; rsync -avz ../deployment WebTeam@lxpc1041:/home/WebTeam/'
		sh 'ssh WebTeam@lxpc1041 "cd /home/WebTeam/deployment/; sh deployment.sh &"'
		echo 'P@S code deployed to Test site Successfully... with PAS version : ' + pas_test_version
              },

			PAS_STAGE_Deploy: {
		sh 'rsync -avz /approot/jenkins/jobs/PAS_TEST_PA11Y/pas.version /approot/jenkins/jobs/PAS_STAGE_Deploy/'
                String pas_stage_version = new File('/approot/jenkins/jobs/PAS_STAGE_Deploy/pas.version').text
                String version = 'Deploying P@S code to Stage P@S Site - PAS Version : ' + pas_stage_version
                echo version
		sh 'cd /approot/JenkinsFile-Project/deployment;rsync -avz ../deployment WebTeam@lxpc1042:/home/WebTeam/'
		sh 'ssh WebTeam@lxpc1042 "cd /home/WebTeam/deployment/; sh deployment.sh &"'
		echo 'P@S code deployed to Stage site Successfully... with PAS version : ' + pas_stage_version
              }
	   )
	}

	stage ('Behat Smoke Test') {
	   echo 'Checking behat site status'
	   build 'PAS_SMOKE_TEST_behat'
	}


	stage ('Behat and Test Ship sites Execution') {
	   echo 'Test Site deployment and Iniating Behat job Execution'

	   parallel ('Behat_Execution_Ocean': {
		echo 'Starting Behat Execution for OCEAN Theme ...'
		build 'PAS_BEHAT-OCEAN'
		sh '/approot/JenkinsFile-Project/scripts/Jenkins-DEV_Flag-Notification.sh'
		},

			Behat_Execution_Pax_V2: {
		echo 'Starting Behat Execution for PAX-V2 Theme ...'
		build 'PAS_BEHAT-PAX_V2'
		},

			PAS_Test_Ship_Deploy: {
		echo 'Executing Test Ship site deployment'
		sh 'rsync -avz /approot/jenkins/jobs/PAS_TEST_Deploy/pas.version /approot/jenkins/jobs/PAS_TEST_SHIP/'
                String pas_testShip_version = new File('/approot/jenkins/jobs/PAS_TEST_SHIP/pas.version').text
                String version = 'Deploying P@S code to Test P@S Site - PAS Version : ' + pas_testShip_version
                echo version
		//build 'PAS_TEST_SHIP'
		},

			PAS_Behat_db: {
		echo 'Initiating Behat Database refresh job once Beaht deployment and Behat execution completes.'
		sleep 10
		build(job: 'PAS_Behat_db', wait:false)
		}
	   )
	}
	
	stage ('ProductionReleaseCheckPoint') {
		sh 'rsync -avz /approot/jenkins/jobs/PAS_TEST_SHIP/pas.version /approot/jenkins/jobs/PAS_SHORE_PRO/'
		String shore_version = new File('/approot/jenkins/jobs/PAS_SHORE_PRO/pas.version').text
                String version = 'We are ready to Promote P@S code to Shoreside Production site with PAS Version : ' + shore_version
                echo version
		sh '/approot/JenkinsFile-Project/scripts/Jenkins-DEV_Flag-Notification.sh'
	}

    } catch(error) {
        throw error
    } finally {
        
    }
   echo 'Execution Completed Successfully......!'
}
