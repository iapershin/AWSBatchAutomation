pipeline {
    agent any
    parameters {
        string(name: 'BRANCH_GIT', defaultValue: 'master', description: '')
        choice(name: 'ENVIRONMENT', choices: ['dev','prod'], description: 'Environment, which will be used for deployment')
        choice(name: 'JOB_NAME', choices: ['batch-job-template'], description: 'Choose job for deployment')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Choose Docker tag')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    tools {
        terraform '<terraform_tool>'
    }
    environment {
        TF_IN_AUTOMATION      = '1'
    }

    stages {
        stage('Plan') {
            steps {
                dir("environments/${ENVIRONMENT}") {
                    sh 'terraform init -input=false'
                    sh """terraform plan -input=false \
                        -var 'image_tag=${IMAGE_TAG}' \
                        --var-file=environment-variables.tfvars \
                        -target=module.${ENVIRONMENT}-${JOB_NAME} \
                        -out tfplan
                    """
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    dir("environments/${ENVIRONMENT}") {
                        def plan = readFile 'tfplan.txt'
                        input message: "Do you want to apply the plan?",
                                parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                    }
                }
            }
        }

        stage('Apply') {
            steps {
                dir("environments/${ENVIRONMENT}") {
                    sh "terraform apply -input=false tfplan"
                }
            }
        }
    }

    /*post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
        }
    } */
}