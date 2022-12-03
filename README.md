# Cloud-Security
## IAM Role
### Create Role
1. create IAM role
    * select AWS Service
    * select EC2
    * add AmazonS3FullAccess policy
    * fill name and description
    * create role
1. Apply IAM role for Amazon EC2
    * create new ec2 instance (using Amazon linux)
    * connect to created instance
    * run 
    ``` 
    aws s3 ls
    ```
    * modify IAM role and choose created role on previous step
    * run command again

### Create temporary role
1. create IAM role
    * select AWS Account
    * add AmazonRDSFullAccess policy
    * fill name and description
    * create role
1. create IAM policy for STS
    * copy arn from role page
    * click create new policy
    * select STS service
    * set action Write > AssumeRole
    * select specify ARN
    * Add ARN that copied(ARN of role that created in previous step)
1. attach IAM policy to group
    * select group to get the dba permission
    * click permission tab
    * click add permission and attach policy

## Cloud Auditing Tools
### Environment setup
#### Setup AWS CLI
* create user for programmatic access
* Environment setup
```
export AWS_ACCESS_KEY_ID="accesskey"
export AWS_SECRET_ACCESS_KEY="secretkey"
export AWS_DEFAULT_REGION="us-east-1"
```
* aws configure

#### Setup SAD Cloud
* git clone https://github.com/nccgroup/sadcloud.git
* cd sadcloud
* ssh-keygen -t rsa -b 4096 -f data/ssh_keys/terraform_rsa
* Or using providers.tf
```
provider "aws" {
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
  region     = "ap-southeast-1"
}
```

* terraform init
* Uncomment modules in terraform.vars
* terraform plan
* terraform apply
* terraform apply --var="all_findings=true"
* terraform destroy

### ScoutSuite
* pip install scoutsuite
* scout --help
* scout aws
* scout aws --max-rate=2
* Minimal Permission
    - ReadOnlyAccess
    - SecurityAudit
    - or custom minimal permission [here](https://github.com/nccgroup/ScoutSuite/wiki/AWS-Minimal-Privileges-Policy)
* See all rulesets [here](https://github.com/nccgroup/ScoutSuite/tree/master/ScoutSuite/providers/aws/rules/rulesets)
* scout aws --ruleset custom.json
* scout aws --exceptions exceptions.json --no-browser
* scout aws --skip SERVICES
* scout aws --result-format json
* scout aws -r REGIONS
* scout aws -xr EXCLUDE_REGIONS

### Prowler
* prowler -h
* prowler -r [region]
* prowler -l
* prowler -l -g [group-name]
* prowler -g [group-name]
* prowler -c check310
* prowler -E check310 // Except
* prowler -g [group-name] -E [check-id]
* prowler -M csv,json,json-asff,html,text,junit-xml
* prowler -M csv -B my-bucket/folder/ // Upload to amazon s3
* docker run -it --rm --name prowler --env AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY --env AWS_SESSION_TOKEN toniblyx/prowler:latest

### Trivy
* trivy image python:3.4-alpine
* trivy image --reset python:3.4-alpine
* trivy image --exit-code 2 python:3.4-alpine
* trivy image --list-all-pkgs python:3.4-alpine
* trivy image --serverity CRITICAL,HIGH,MEDIUM python:3.4-alpine
* trivy image --ignore-unfixed python:3.4-alpine
* trivy repo https://github.com/AnaisUrlichs/react-article-display
* git clone https://github.com/AnaisUrlichs/react-article-display
* trivy config ./manifest
* git clone https://github.com/nccgroup/sadcloud
* trivy config sadcloud
* trivy fs --security-checks vuln,secret,config [path to source code]
* trivy k8s --report summary cluster

### TFSec
* tfsec /path/to/source-code
* tfsec /path/to/source-code -s
* tfsec /path/to/source-code --run-statistics
* Ignore warnings (Inline)
  - #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  - #tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-enable-bucket-logging
  - #tfsec:ignore:aws-s3-enable-bucket-encryption:exp:2025-01-02
* tfsec -e ignore:aws-s3-enable-bucket-encryption,aws-s3-enable-bucket-logging
* tfsec --format [JSON|CSV|Checkstyle|Sarif|JUnit]
* create config file at .tfsec/config.json or .tfsec/config.yml
  - .tfsec/config.json
      ```
      {
        "minimum_severity": "MEDIUM",
        "severity_overrides": {
            "CUS002": "ERROR",
            "aws-s3-enable-versioning": "LOW"
        },
        "exclude": ["CUS002", "aws-s3-enable-versioning"]
      }
      ```

      - .tfsec/config.yml
      ```
      minimum_severity: MEDIUM
      severity_overrides:
        CUS002: ERROR
        aws-s3-enable-versioning: HIGH
      exclude:
        - CUS002
        - aws-s3-enable-versioning
      ```
* docker run --rm -it -v "$(pwd):/src" aquasec/tfsec /src

### CloudSploit
* git clone https://github.com/aquasecurity/cloudsploit.git
* cd cloudsploit
* npm install
* ./index.js -h

### Checkov
* pip install checkov
* checkov -l
* checkov -d /path/to/tf
* checkov -s
* checkov --framework terraform
* checkov --skip-framework dockerfile
* checkov –check CKV_AWS_123
* checkov -check [LOW|MEDIUM|HIGH|CRITICAL]
* checkov -skip-check CKV_AWS_123
* checkov -skip-check [LOW|MEDIUM|HIGH|CRITICAL]
* checkov --soft-fail-on SOFT_FAIL_ON [LOW|MEDIUM|HIGH|CRITICAL]
* checkov --hard-fail-on HARD_FAIL_ON [LOW|MEDIUM|HIGH|CRITICAL]

## Continuous Compliance
### AWS Config
* click Add rule
* select desired_instance_type rule
* Set rule parameter
  - instance_type = t2.micro
* Select rule and click action button and choose Remediation action
* Set remediation action to AWS-ResizeInstance
* Set resource id parameter to instanceID
* Set parameter
  - instance type = t2.micro
* Manual remediate
  - select non-compliance rule
  - click remediate

### Chef Inspec
* inspec exec linux_control_01.rb
* inspec exec docker_control_01.rb
* inspec detect -t aws://
* inspec detect -t aws://[region]/[profile]
* inspec exec inside-container_01.rb -t docker://[Container-ID]
* inspec exec inside-container_01.rb -t ssh://[User]@[Server-IP]
* git clone https://github.com/dev-sec/linux-baseline
* inspec exec linux-baseline-master/-t docker://[Container-ID]
* inspec exec https://github.com/dev-sec/cis-docker-benchmark
* inspec exec https://github.com/dev-sec/cis-kubernetes-benchmark
* inspec supermarket profiles
* inspec supermarket exec dev-sec/linux-baseline -t docker://[Container-ID]
* inspec init profile --platform os my-profile
* inspec check my-profile
* inspec vendor
* inspec shell
  - help
  - help resources
  - help file
  - file('/path/to/file').exists?
  - file('/path/to/file').content
  - file('/path/to/file').methods
* inspec shell -t ssh://[User]@[Server-IP] -i [key.pem] 
* inspec shell -t docker://[Container-ID]
* inspec init profile --platform aws aws-profile
* inspec shell --depends aws-profile -t aws://ap-southeast-1
  - aws_ec2_instances.instance_ids
  - aws_ec2_instance('instance-id').exists?
  - aws_ec2_instance('instance-id').instance_type
  - aws_ec2_instance('instance-id').vpc_id

## Securing infrastructure
### Flow Log
1. create CloudWatch log group
    * go to CloudWatch
    * select Log > Log group
    * Actions > create log group 
1. create IAM role
    * follow this [document](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-cwl.html)
    * create policy
    ```
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
          ],
          "Resource": "*"
        }
      ]
    }   
    ```
    * create role (choose create custom trust policy) update principal to this
    ```
    "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
    }
    ```
    * Add permission that created earlier

1. create flow log
    * select VPC, subnet or network interface that you want to flow log
    * Set Filter
    * Set log group and flowlog role

References
* [Well-Architected Security Pillars](https://docs.aws.amazon.com/pdfs/wellarchitected/latest/security-pillar/wellarchitected-security-pillar.pdf#welcome)
* [AWS Security Checklist](https://d1.awsstatic.com/whitepapers/Security/AWS_Security_Checklist.pdf)
* [Using AWS Systems Manager to run compliance scans using InSpec by Chef](https://aws.amazon.com/blogs/mt/using-aws-systems-manager-to-run-compliance-scans-using-inspec-by-chef)
