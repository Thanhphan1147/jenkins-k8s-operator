pod_template = '''apiVersion: v1
kind: Pod
spec:
  containers:
  - name: python-tox
    image: ghcr.io/thanhphan1147/python-tox:1.0
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
              } 
            }

            steps {
                sh'''#!/bin/bash
                    echo "$(hostname) $(date) : Running in $(pwd) as $(whoami)"
                    which python
                    which python3
                    python -m tox -e lint
                '''

            }
        }

        stage('Unit') {
            agent { 
              kubernetes {
                yaml pod_template
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
