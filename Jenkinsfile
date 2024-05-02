podTemplate(yaml: '''
    apiVersion: v1
    kind: Pod
    metadata:
    labels:
        some-label: some-label-value
    spec:
    containers:
    - name: python-tox
      image: python-tox
      command:
      - sleep
      args:
      - 99d
      tty: true
''') {
node(POD_LABEL) {
    stage('Lint') {
      sh '''#!/bin/bash
          python3 -m tox lint
      '''
    }
  }
}
