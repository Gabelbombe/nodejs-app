pipeline {
  agent {
    docker {
      image 'ehime/build-container:latest'
    }
  }
  stages {
      stage('Build') {
        steps {
          sh 'npm install'
        }
      }

      stage('Create Packer AMI') {
          steps {
            withCredentials([
              usernamePassword(credentialsId: 'ada90a34-30ef-47fb-8a7f-a97fe69ff93f', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY')
            ]) {
              sh 'packer build -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} packer/packer.json'
          }
        }
      }
      stage('Application Unit Tests') {
        steps {
          sh 'echo -e "You should insert your steps for REAL testing here-ish..'
        }
      }
      stage('Amazon Services Deployment') {
        steps {
            withCredentials([
              usernamePassword(credentialsId: 'ada90a34-30ef-47fb-8a7f-a97fe69ff93f', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY'),
              usernamePassword(credentialsId: '2facaea2-613b-4f34-9fb7-1dc2daf25c45', passwordVariable: 'REPO_PASS',  usernameVariable: 'REPO_USER'),
            ]) {
              sh '[ -d nodejs-app-terraform ] && rm -rf nodejs-app-terraform'
              sh 'git clone https://github.com/ehime/nodejs-app-terraform.git'
              sh '''
                 cd nodejs-app-terraform
                 terraform init
                 terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET} -var region=${REGION}
                 git add _state/*
                 git -c user.name="ehime" -c user.email="dodomeki@gmail.com" commit -m "TF-State update from Jenkins"
                 git push https://${REPO_USER}:${REPO_PASS}@github.com/ehime/nodejs-app-terraform.git master
              '''
          }
      }
    }

    environment {
      npm_config_cache = 'npm-cache'
    }
  }
}
