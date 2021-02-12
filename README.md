# TechChallengeApp-Deployment

This project is designed to deploy [TechChallengeApp](https://github.com/servian/TechChallengeApp) on Amazon AWS. Some AWS resources like RDS cluster, Application Load Balancer (ALB) and AutoScaling group were used to ensure the application availability.

As a simple application, the system was designed with moderate cost association: micro application instance type, two Availability Zones (AZ's), default of only one web application instance running. Optionally, you could increase the minimum number of application instances to 2 and will see an increase in availability and cost.

The TechChallengeApp web application will be inside an Auto Scaling Group (ASG) hence instance replacement will happen if there's a failure. Only port 80 will be publicly reachable for web nodes while ssh access will be available through Bastion host for instances maintenance. Like all other configuration items, the AllowList network can be re-configured via the entries in <span>secret.tfvars</span> residents in folder aws/ which can be found in the project root folder.

Accodring to the requests of TechChallengeApp, a 2-instance RDS PostgreSQL 10.7 cluster will be created as the DB backend of the application.

A basic dashboard will be created after deployment for important application metrics watching.

## Pre-requisites

Although the deployment tool itself was written in terraform script, an Ubuntu environment with Bash, wget, unzip and python3-pip installed is still necessary for help scripts running. So please run it in an Ubuntu-20.04 or above (Dockerised Ubuntu is also good) environment.

A help script named <span>dependency-install.sh</span> has been included in this project for initial terraform and awscli installation. ~/.profile will be touched for adding executables into user $PATH so you may want to create a separate user for the installation to avoid touching the current user environment.

The following instructions demonstrate how to create a dockerized environment and install/config the dependencies with <span>dependency-install.sh</span>. A new ssh key will be generated as well as the default AWS profile configuration during the process. Due to the potential impact over the user environment, these steps were not include in the help script hence need to be done manually. Please ignore the following instructions if you've already had the desired Ubuntu environment with terraform and awscli running properly.

```console
$ docker run --rm -it ubuntu:focal bash
root@ed0985cf9a02:/# apt-get -y update && apt-get -y install git bash wget unzip python3-pip vim
root@ed0985cf9a02:/# adduser --disabled-password --gecos GECOS ubuntu && su - ubuntu
ubuntu@ed0985cf9a02:~$ git clone https://github.com/samuelhbne/TechChallengeApp-Deployment
ubuntu@ed0985cf9a02:~$ cd TechChallengeApp-Deployment && ./dependency-install.sh
ubuntu@ed0985cf9a02:~/TechChallengeApp-Deployment$ source ~/.profile
ubuntu@ed0985cf9a02:~/TechChallengeApp-Deployment$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa):
...
ubuntu@ed0985cf9a02:~$ terraform -v
Terraform v0.14.6
ubuntu@ed0985cf9a02:~/TechChallengeApp-Deployment$
```

*** NOTE: Please ensure the aws credential inputed has been granted with AmazonEC2FullAccess. Or the coming stack deployment will fail otherwise.

Although awscli installation is not necessary, The terraform scripts still need to read AWS credentials and config from ~/.aws/ hence it could be easier to config credentials and config with awscli first.

## Crucial configuration items

You may want to re-configured some default settings before deployment. All setting items can be overrided with the entries in <span>secret.tfvars</span> which residents in folder aws of the project root.

### AWS_REGION

AWS region to create the stack

```console
variable "AWS_REGION" {
  default     = "ap-northeast-2"
}
```

### AWS_ACCESS_KEY_ID

AWS credential ID for stack deployment. It must be granted with AmazonRDSFullAccess and AmazonEC2FullAccess previleges. Or the following stack creation will be failed otherwise.

```console
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key ID"
}
```

### AWS_SECRET_ACCESS_KEY

AWS credential secret for stack deployment.

```console
variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS access secret"
}
```

### PUBLIC_KEY

SSH public key to login into instance

```console
variable "PUBLIC_KEY" {
  type        = string
}
```

### ENV

Prefix of all AWS resource names created by the stack

```console
variable "ENV" {
  default     = "tech-challenge-syd"
}
```

### allowlist_bastion

Allowlist network for Bastion host ssh access allowing.

```console
variable "allowlist_bastion" {
  default     = ["0.0.0.0/0"]
}
```

### ami_web

AMI image id of Ubuntu server for web app running. By default, ubuntu-20.04-LTS AMI released on 20200907 will be selected.

```console
variable "ami_web" {
  default     = "ami-0d767dd04ac152743"
}
```

You may get the latest image available in the deployment region with the following command:

```console
aws ec2 describe-images --region ap-southeast-2 --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64* --query 'Images[*].[ImageId,CreationDate,Name]' --output text|sort -k2 -r
```

### ami_bastion

AMI image id of Ubuntu server for Bastion host running. By default, ubuntu-20.04-LTS AMI released on 20200907 will be selected. You may want to replace it with your own image in which additional hardening setting has been applied.

```console
variable "ami_bastion" {
  default     = "ami-0d767dd04ac152743"
}
```

## Deploying stack

You can change the configuration items in <span>secret.tfvars</span> first then run "terraform apply" subsequently:

```console
$ git clone https://github.com/samuelhbne/TechChallengeApp-Deployment.git
$ cd TechChallengeApp-Deployment/aws
$ cp -a secret.tfvars.sample secret.tfvars
$ vim secret.tfvars
...
$ terraform init
...
$ terraform apply -var-file=secret.tfvars
...
  Enter a value: yes
...
Outputs:

db_endpoint = "tech-challenge-syd-aurora-cluster-pg.cluster-cqf0rcbyoyln.ap-southeast-2.rds.amazonaws.com"
db_reader_endpoint = "tech-challenge-syd-aurora-cluster-pg.cluster-ro-cqf0rcbyoyln.ap-southeast-2.rds.amazonaws.com"
elb_dns_name = "tech-challenge-syd-elb1-1929977202.ap-southeast-2.elb.amazonaws.com"
$
```

elb_dns_name will be displayed as the result after "terraform apply" execution. You may want to copy the address and access it from the browser to verify if the application has been running successfully on AWS. It might take miniutes for the whole stack going up and running so thank you for your patience.

## Recovering App state after fresh stack deployment

App state can be restored through RDS cluster restoration from DB snapshot, which can be done through RDS console pannel.

## Undeploying stack

As a terraform stack, "terraform destroy" command will unprovision all AWS resources it deployed previously.

```console
$ terraform destroy
...
Destroy complete! Resources: 16 destroyed.
$
```

## Monitoring Plan

A default dashboard for important application metrics morning will be created after the deployment, which can be accessed from AWS CloudWatch console panel.

In a more sophisticated case, 3rd party tools like Splunk Enterprise could be useful for digesting important system log and application log (/var/log/auth.log, /var/log/syslog access.log tec.). Hence alarms can be set in Splunk to check events like ssh login failure and subsequently followed by triggering a PagerDuty push. Unlicensed Splunk instance currently allows 500MB per day, which could be enough for covering a small decent application.

## TODO

Although not listed as requirements, I would do the following if I have more time:

- Autoscaling policies

- Put WebApp nodes into private subnet

- Add CloudWatch alarms for urgent edge events
