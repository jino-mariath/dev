#!/usr/bin/env groovy
import hudson.FilePath
import jenkins.model.Jenkins

job('PA11y_Test') {
   echo 'Executing ADA Test - PA11Y script'
   //build 'PAS_TEST_PA11Y
   blockOn(['PAS_Dev_Language', 'Sonar_Build_Status']) {
       blockLevel('GLOBAL')
       scanQueueFor('ALL')
    }    
}
        
