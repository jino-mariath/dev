#!/bin/bash

JENKINS_ROOT=`whereis jenkins | cut -d ':' -f2`;if [ -z "$JENKINS_ROOT" ]; then JENKINS_ROOT=`env | grep -i jenkins_home | cut -d '=' -f2`; elif [ -z "$JENKINS_ROOT" ]; then echo "Unable to locate Jenkins Home Directory"; else echo "Jenkins Home Dir is  - $JENKINS_ROOT"; fi

PAS_VERSION=`cat $JENKINS_ROOT/jobs/PAS_DEV/var.properties | grep PAS_VERSION | cut -d '=' -f2`
BUILD_NUMBER=`cat $JENKINS_ROOT/jobs/PAS_DEV/var.properties | grep VERSION_BUILD_NUMBER | cut -d '=' -f2`
DEV_WORKSPACE="$JENKINS_ROOT/jobs/PAS_DEV/workspace"

#Start build package and exculde unnecessary files
touch /tmp/exclude-list
 echo "*.git
*.gitignore
*.gitmodules
*.hg
*.hgignore
*.hgrags
*.bzr
*.bzrignore
*.bzrtags
*.svn
*.sql
Vagrantfile
*settings.php
ci/behat
ci/build
ci/dbreplication
ci/deployment
ci/drush_aliases
ci/drush_modules_manager
ci/jenkins_on_board
ci/jmeter
ci/mail-list.txt
ci/nodejs
ci/phpunit
ci/selenium
ci/shell_scripts
sites/default/localshore
sites/default/*" > /tmp/exclude-list
cd $DEV_WORKSPACE
echo $PAS_VERSION-$BUILD_NUMBER > pas.version
ls -lah 
rsync -avz pas.version PAS/
cd PAS
tar -czf $DEV_WORKSPACE/princessatsea-$PAS_VERSION-$BUILD_NUMBER.tar.gz --exclude-from=/tmp/exclude-list .
rm -f pas.version
echo "BUILD FINISHED"

