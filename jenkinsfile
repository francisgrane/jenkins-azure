pipeline {
    agent any

    environment {
        // Reference Azure Service Principal credentials stored in Jenkins (credentials ID: 'azure-credentials')
        ARM_CLIENT_ID = credentials('azure-credentials')?.CLIENT_ID
        ARM_CLIENT_SECRET = credentials('azure-credentials')?.CLIENT_SECRET
        ARM_TENANT_ID = credentials('azure-credentials')?.TENANT_ID
        ARM_SUBSCRIPTION_ID = credentials('azure-credentials')?.SUBSCRIPTION_ID
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the Terraform configuration from your Git repository
                git 'https://github.com/francisgrane/jenkins-azure.git'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform with Azure authentication using credentials from Jenkins
                    sh '''
                    terraform init
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run Terraform plan to show what changes will be made
                    sh '''
                    terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Approval: Apply or Destroy') {
            steps {
                script {
                    // Prompt for manual approval to apply or destroy
                    def action = input message: "Choose whether to Apply or Destroy", parameters: [
                        [$class: 'ChoiceParameterDefinition', choices: ['Apply', 'Destroy'], description: 'Select Apply to create resources or Destroy to tear down the infrastructure', name: 'action']
                    ]
                    
                    // Store the selected action to use later
                    env.ACTION = action
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    // Proceed only if 'Apply' was selected
                    return env.ACTION == 'Apply'
                }
            }
            steps {
                script {
                    // Apply the Terraform plan to create resources in Azure
                    sh '''
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    // Proceed only if 'Destroy' was selected
                    return env.ACTION == 'Destroy'
                }
            }
            steps {
                script {
                    // Run Terraform destroy to remove resources from Azure
                    sh '''
                    terraform destroy -auto-approve
                    '''
                }
            }
        }

        stage('Post Apply or Destroy') {
            steps {
                script {
                    // Any post-apply or post-destroy actions, like sending notifications or updating a status page
                    echo "Terraform ${env.ACTION} completed successfully!"
                }
            }
        }
    }

    post {
        success {
            // Success notifications or actions
            echo "Terraform ${env.ACTION} completed successfully! Resources are either created or destroyed in Azure."
        }
        failure {
            // Failure notifications or actions
            echo "Terraform ${env.ACTION} failed. Please review the logs for errors."
        }
    }
}
