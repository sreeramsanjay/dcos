**All the modules needs to be put under 'module' folder and reference in the 'stack' folder**
======

**Using this repo**
  * You should have terraform installed if not having download it from https://www.terraform.io/downloads.html
  * You should have the AWS Key and Access

## Usage instructions:

1. terraform init
2. terraform plan
3. terraform apply

#### Note:
1. Update the files under stacks/<stacks_name> with appropriate values and only these are the manual changes needed before running terraform.
2. Review the changes on plan stage before running terraform apply.
3. Any changes made with aws-cli/console/sdk or any other awsapi will be lost with terraform apply.
4. Few changes may result permanent deletion of resources and may not possible to restore it back.
5. Update the variable.tf file with appropriate values.
6. Update the code with test cases before using on production environment

#### Version: Terraform v0.9.4

### This repository directory structure contains stacks, modules, dcos-post-install and ansible-dcos-bootstrap.

### Modules:

- Modules directory contains the reusable code to build the aws infrastructure using terraform and each modules will be used by single or multiple stacks to build the infrastructures.
- It is not recommended to update the modules as this may impact the dependent stacks.

### Stacks:

- Stacks contains sub directory which builds actual aws infrastructures and each of these subdirectory contains mail.cf and variables.tf files to call the subsequent modules.
- main.cf file will call the modules and pass the input variables to build the resources
- varaible.tf fill hold all variables and we need update the variables as needed on this file

### ansible-dcos-bootstrap:

- This directory contains the ansible playbooks to create the mesosphere config.yaml file then generate mesosphere install files and upload them to S3 bucket.
- Any config changes related mesosphere bootstrap needs to update here and this playbooks will be executed as a part of terraform stack dcos_bs where we need to pass input variables to this ansible playbook using userdata.sh file.

### dcos-post-install:

- This directory contains the bash scripts to perform the post install steps on mesosphere private agents like node attributes and docker garbage collector.
- mesosphere private agents will download the post install scripts during the bootstrap of private agent and arguments for this scripts needs to be pass from userdata.sh scripts located on respective stacks of terraform.

### Stacks details:

#### vpc:

- This stack build the vpc with /22 cidr and 6 subnet on two availability zone. We may need to update/change module vpc in order to change vpc subnets design etc. VPN Tunnel is disabled on this module as we are using cisco for vpn.
- Any changes to vpc route tables has to be updated on this vpc modules

##### vpc stack creates below resources:

1. vpc and subnets
2. dmz route tables
3. s3 endpoint
4. vpc_flowlogs

#### cisco:

- This stack builds two cisco csr 1000v virtual appliances one different availability from aws market place on BYOL license model.
- we need to update the varaible.tf file with dmz subnets, ami-id, instance types and public ip address for ssh access & all traffic for tunnel communication.

##### Cisco stack creates below resources:

1. two EC2 instances with elastic ip address
2. ec2 instance profile(iam role and policy)
3. ec2 security group.

#### dcos_infra:

- This stack build the all the dependent resources needed for mesosphere and this need variable values from vpc stacks like subnet ids, cisco security groups id.

##### dcos_infra stack creates below resources:

1. EC2 instance profiles for master, agents and bootstrap
2. S3 buckets for bootstrap files and zookeeper exhibitor storage with bucket policy
3. Elastic load balancer
4. security groups

##### dcos_bs:

- This will build an EC2 instance to build mesosphere bootstrap node which is generate install file then upload them to s3 bucket, this stack need inputs from vpc & dcos_infra stacks as a variables.

##### dcos_bs stack creates below resources:
1. EC2 instance

#### dcos_master:

- This will build auto scaling groups for mesosphere master and needs inputs from vpc, dcos_infra and dcos_bs as variables like elb name, subnets ids, iam profiles, bootstrap url etc.

##### dcos_bs stack creates below resources:
1. Auto scaling launch configuration
2. Auto scaling group

    dcos_priv: This will build auto scaling groups for mesosphere master and needs inputs from vpc, dcos_infra and dcos_bs as variables like elb name, subnets ids, iam profiles, bootstrap url etc.

    dcos_priv stack creates below resources:
      1.Auto scaling launch configuration
      2.Auto scaling group

    dcos_pub: This will build auto scaling groups for mesosphere master and needs inputs from vpc, dcos_infra and dcos_bs as variables like elb name, subnets ids, iam profiles, bootstrap url etc.

    dcos_pub stack creates below resources:
      1.Auto scaling launch configuration
      2.Auto scaling group

    All these modules uses centos 7.3 base image imported from Mckinsey on-prem and below are the packages loaded on these image.
      1.Loaded with all mesosphere prerequisites using dcos-prerequisite ansible playbook
      2.aws-cli
      3.pip
      4.python-dateutil
      5.ec2-metadata
      6.cloud-init

    Manually provisioned infrastructure:
      All the infrastructure is provisioned using the terraform code available in this repository.
      Route53 and iaas-pilot-tfstatus s3 bucket are the only resource created manually from aws console.
