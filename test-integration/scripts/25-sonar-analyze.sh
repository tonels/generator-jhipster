#!/bin/bash

source $(dirname $0)/00-init-env.sh

#--------------------------------------------------
# Launch Sonar analysis
#--------------------------------------------------
cd "$JHI_FOLDER_APP"

if [[ "$JHI_APP" = "ngx-default" && "$TRAVIS_REPO_SLUG" = "jhipster/generator-jhipster" && "$TRAVIS_BRANCH" = "master" && "$TRAVIS_PULL_REQUEST" = "false" ]]; then
    echo "*** Sonar analyze for master branch"
    ./mvnw org.jacoco:jacoco-maven-plugin:prepare-agent sonar:sonar \
        -Dsonar.host.url=https://sonarcloud.io \
        -Dsonar.login=$SONAR_TOKEN

elif [[ $JHI_SONAR = 1 ]]; then
    echo "*** Sonar analyze locally"
    ./mvnw org.jacoco:jacoco-maven-plugin:prepare-agent sonar:sonar \
        -Dsonar.host.url=http://localhost:9001
    
    sleep 20
    echo "*** Sonar results:"
    curl http://localhost:9001/api/measures/component\?componentKey\=io.github.jhipster.sample%3Ajhipster-sample-application\&metricKeys\=bugs%2Ccoverage%2Cvulnerabilities%2Cduplicated_lines_density%2Ccode_smells | jq

else
    echo "*** No sonar analyze"

fi
