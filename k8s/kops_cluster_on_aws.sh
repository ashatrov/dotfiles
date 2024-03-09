#!/bin/bash
set -x #echo on

echo '' > .export_vars.sh

### Install KOPS
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/


### Install kubectl
curl -Lo kubectl https://dl.k8s.io/release/$(curl -s -L https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


### Install awc-cli
#pip install awscli
sudo apt update
sudo apt install awscli


### aws configure
echo "======= COFIGURE AWS WITH YOUR CURRENT USER ======"
echo "======= Ge=nerate access token following this URL ======"
aws ec2 describe-regions --query 'Regions[*].RegionName'
echo "URL: https://us-east-1.console.aws.amazon.com/iam/home#/security_credentials"
aws configure

### kOps IAM user
read -e -p "Enter user group name (e.g. kops): " -i "kops" USERGROUPNAME
echo "export USERGROUPNAME=${USERGROUPNAME}" >> .export_vars.sh
aws iam create-group --group-name ${USERGROUPNAME}

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name ${USERGROUPNAME}
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name ${USERGROUPNAME}
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name ${USERGROUPNAME}
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name ${USERGROUPNAME}
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name ${USERGROUPNAME}
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess --group-name ${USERGROUPNAME}
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess --group-name ${USERGROUPNAME}

read -e -p "Enter user name (e.g. kops): " -i "kops" USERNAME
echo "export USERNAME=${USERNAME}" >> .export_vars.sh
aws iam create-user --user-name ${USERNAME}

aws iam add-user-to-group --user-name ${USERNAME} --group-name ${USERGROUPNAME}

aws iam create-access-key --user-name ${USERNAME}


# configure the aws client to use your new IAM user
echo "======= COFIGURE AWS WITH !!!!NEW!!!! USER ACCESS TOKEN ======"
aws configure
aws iam list-users
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >> .export_vars.sh
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >> .export_vars.sh

export CURRENTREGION=$(aws configure get region)
echo "export CURRENTREGION=${CURRENTREGION}" >> .export_vars.sh


# Create S3 buckets
read -e -p "Enter bucket name (e.g. my-kops-test-bucket-r3i7h3d): " -i "my-kops-test-bucket-r3i7h3d" KOPSBUCKET
echo "export KOPSBUCKET=${KOPSBUCKET}" >> .export_vars.sh
aws s3api create-bucket --bucket ${KOPSBUCKET} --create-bucket-configuration LocationConstraint=${CURRENTREGION}
aws s3api put-bucket-versioning --bucket ${KOPSBUCKET}  --versioning-configuration Status=Enabled
aws s3api create-bucket \
    --bucket ${KOPSBUCKET}-oidc-store \
    --region ${CURRENTREGION} \
    --object-ownership BucketOwnerPreferred \
    --create-bucket-configuration LocationConstraint=${CURRENTREGION}
aws s3api put-public-access-block \
    --bucket ${KOPSBUCKET}-oidc-store \
    --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
aws s3api put-bucket-acl \
    --bucket ${KOPSBUCKET}-oidc-store \
    --acl public-read
aws s3api put-bucket-encryption --bucket ${KOPSBUCKET} --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'



# Create cluster
read -e -p 'Enter kluster name (e.g. fleetman.k8s.local where .k8s.local part is !!!MANDATORY!!!): ' -i "fleetman.k8s.local" NAME
export NAME=${NAME} ; echo $NAME
echo "export NAME=${NAME}" >> .export_vars.sh
export KOPS_STATE_STORE=s3://${KOPSBUCKET} ; echo $KOPSBUCKET
echo "export KOPS_STATE_STORE=${KOPS_STATE_STORE}" >> .export_vars.sh


aws ec2 describe-availability-zones
export ALLAVAILABLEZONES=`aws ec2 describe-availability-zones --query 'AvailabilityZones[*].ZoneName' --output text | tr '\t' ','`
echo "export ALLAVAILABLEZONES=${ALLAVAILABLEZONES}" >> .export_vars.sh
read -e -p "Enter availability zones in comma-separated format (e.g. ${ALLAVAILABLEZONES}): " -i ${ALLAVAILABLEZONES} CLUSTERZONES
echo "export CLUSTERZONES=${CLUSTERZONES}" >> .export_vars.sh
kops create cluster \
    --name=${NAME} \
    --cloud=aws \
    --zones=${CLUSTERZONES} \
    --discovery-store=s3://${KOPSBUCKET}-oidc-store/${NAME}/discovery

kops update cluster --name ${NAME} --state=${KOPS_STATE_STORE} --yes --admin=87600h

kops validate cluster --state=${KOPS_STATE_STORE} --wait 10m

kubectl get nodes

kubectl get all

kubectl -n kube-system get po


