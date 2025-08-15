#!/bin/bash

echo "FileSystemId=$(aws efs describe-file-systems --query "FileSystems[0].FileSystemId" --output text)" >> /etc/environment

echo "MYSQL_HOST=$(aws rds describe-db-instances --query "DBInstances[0].Endpoint.Address" --output text)" >> /etc/environment

echo "MountPoint=/mnt/efs" >> /etc/environment

source /etc/environment

sudo su

dnf install -y mariadb105

dnf install -y docker

dnf install -y aws-cli

dnf install -y nfs-utils

mkdir -p /mnt/efs

echo -e '#!/bin/bash\nMountPoint=/mnt/efs\nFileSystemId=$(aws efs describe-file-systems --query "FileSystems[0].FileSystemId" --output text)\nMYSQL_HOST=$(aws rds describe-db-instances --query "DBInstances[0].Endpoint.Address" --output text)\nexport MountPoint\nexport FileSystemId\nexport MYSQL_HOST' >> /etc/profile.d/variavel.sh

chmod +x /etc/profile.d/variavel.sh

sh /etc/profile.d/variavel.sh

echo -e '#!/bin/bash
set -a
source /etc/environment
set +a
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "$FileSystemId.efs.us-east-2.amazonaws.com:/" "$MountPoint"' > /home/ec2-user/mount.sh

chmod +x /home/ec2-user/mount.sh

sh /home/ec2-user/mount.sh

curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

sytemctl enable docker

systemctl start docker

aws s3 cp s3://docker-wordpress-files/.env /mnt/efs

aws s3 cp s3://docker-wordpress-files/docker-compose.yml /mnt/efs

cd /mnt/efs

source /etc/environment

echo "MYSQL_HOST=$MYSQL_HOST" >> /mnt/efs/.env

docker-compose up -d
