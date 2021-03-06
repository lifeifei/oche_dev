### Prerequisite
- vagrant
- AWS account with administrator permissions
- a Keypair in your aws account for provisioning EC2

### Installation
Download Vagrant file from https://github.com/lifeifei/oche_dev/blob/master/ops/vagrant/Vagrantfile
```sh
$ vagrant up
$ vagrant ssh
```
This will start the virtual machine with docker provisioned. Once you log in the vagrant box, please run the following commands to provision and deploy training environment

```sh
$ git clone https://github.com/lifeifei/oche_dev.git
$ cd oche_dev
$ export AWS_ACCESS_KEY_ID=xxxx
$ export AWS_SECRET_ACCESS_KEY=xxxxx
$ export AWS_DEFAULT_REGION=xxxxx #ap-southeast-2
$ cd ops
$ ./provision_get.sh training  # get terraform modules for provision
$ SSH_KEY_NAME=[ssh_key_pair_name]  ./provision_plan.sh training  # create provision plan
$ SSH_KEY_NAME=[ssh_key_pair_name]  APPLY=true ./provision_plan.sh training  # apply provision plan
$ #Also make sure the EC2 instances are up before you move forward (to be improved)

$ ./deploy.sh training 1 # 1 is the build number, it will take about 5 minutes as it will drain the connection from the task first
$ ./verify.sh training 1 # verify the app is running with the specified build number
```

For production environments, it is the same process. Just change your aws credential and environment name from 'training' to 'prod' in the above commands

### Configurations
For provision to set up AWS resources, you can change the following files to configure the resources.
- training environment:  https://github.com/lifeifei/oche_dev/blob/master/ops/terraform/training/main.tf
- prod environment: https://github.com/lifeifei/oche_dev/blob/master/ops/terraform/prod/main.tf
- Configurable variable descriptions please refer to https://github.com/lifeifei/oche_dev/blob/master/ops/terraform/modules/oche/main.tf

For deployment configuration, you can change the following yaml file
- https://github.com/lifeifei/oche_dev/blob/master/ops/deploy/config.yml

### Docker Images for Deployment
Static Contents
- image url: https://hub.docker.com/r/lifeizhou/oche_web/ 
- Dockfile: https://github.com/lifeifei/oche_dev/blob/master/src/web/Dockerfile

Application
- image url: https://hub.docker.com/r/lifeizhou/oche_app/
- Dockfile: https://github.com/lifeifei/oche_dev/blob/master/src/app/Dockerfile