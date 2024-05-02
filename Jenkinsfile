pod_template = '''apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jnlp
    image: 'jenkins/inbound-agent'
    args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
  - name: python-tox
    image: python-tox:1.0
    command:
    - sleep
    args:
    - 99d
'''

pipeline {
    agent none

    stages {
        stage('Lint') {
            agent { 
              kubernetes {
                yaml pod_template
                defaultContainer 'python-tox'
              } 
            }

            steps {
                sh'''#!/bin/bash
                    echo "$(hostname) $(date) : Running in $(pwd) as $(whoami)"
                    python3 -m tox -e lint
                '''

            }
        }

        stage('Unit') {
            agent { 
              kubernetes {
                yaml pod_template
                defaultContainer 'python-tox'
              }   
            }

            steps {
                sh'''#!/bin/bash
                    echo "$(hostname) $(date) : Running in $(pwd) as $(whoami)"
                    python3 -m tox -e unit
                '''
            }
        }
    }
}
