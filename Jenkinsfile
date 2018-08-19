#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

node ('master') {
    try {
	stage ('Test Gate') {
	   echo 'Initating P@S Test and P@S Stage site code deployment..'

		job('PA11y_Test') {
		   echo 'Executing ADA Test - PA11Y script'
		   //build 'PAS_TEST_PA11Y
                   blockOn(['PAS_Dev_Language', 'Sonar_Build_Status']) {
                      blockLevel('GLOBAL')
                      scanQueueFor('ALL')
                   }    
                }
        
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
