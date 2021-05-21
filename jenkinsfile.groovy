pipeline {
    agent any
    parameters {
        string(name: 'BRANCH_GIT', defaultValue: 'master', description: '')
        choice(name: 'ENVIRONMENT', choices: ['dev','prod'], description: 'Environment, which will be used for deployment')
        choice(name: 'JOB_NAME', choices: ['batch-job-template'], description: 'Choose job for deployment')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Choose Docker tag')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }


    stages {
        stage('Plan') {
            when {
                changeset pattern: "*.tf", comparator: "GLOB"
            }
            steps {
                echo 'works'
                }
            }
        }

      

    /*post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    } */
}
