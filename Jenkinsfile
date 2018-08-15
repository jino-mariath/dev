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
 	   sh 'ls -lah /approot/jenkins/jobs/PAS_DEV/workspace/'
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
              //sh 'ssh WebTeam@lxpc1040 "cd /home/WebTeam/deployment/; sh deployment.sh"'
              echo 'P@S code deployed to Dev site Successfully...'
              },

                	Sonar_Test: {
              echo 'Executing Sonar Test - Static Code Analyzer... primcessatsea-PAS_VERSION'
              Sonar_Status = build(job: 'PAS_SONAR_TEST', wait: false, propagate: false).result
	      if(Sonar_Status == 'FAILURE') {
                  echo "Sonar job failed"
                  currentBuild.result = 'UNSTABLE' // of FAILURE
              }  

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
		echo 'Executing DEV site language code'
		sh 'cd /approot/JenkinsFile-Project/deployment; rsync -avz ../deployment WebTeam@lxpc1040:/home/WebTeam/'
		//sh 'ssh WebTeam@lxpc1040 "cd /home/WebTeam/deployment/; sh pas_dev_language.sh", wait: false'
		},

			PAS_Pa11y: {
		echo 'Executing ADA Test - PA11Y script'
		build 'PAS_TEST_PA11Y'
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
		sh 'ssh WebTeam@lxpc1041 "cd /home/WebTeam/deployment/; sh deployment.sh &"'
		echo 'P@S code deployed to Test site Successfully...'
              },

			PAS_STAGE_Deploy: {
		echo 'Copying P@S package to Stage Site'
		echo 'Copying Deployment files...'
		sh 'cd /approot/JenkinsFile-Project/deployment;rsync -avz ../deployment WebTeam@lxpc1042:/home/WebTeam/'
		sh 'ssh WebTeam@lxpc1042 "cd /home/WebTeam/deployment/; sh deployment.sh &"'
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
