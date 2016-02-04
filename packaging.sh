#!/bin/bash

## Source: http://aws.amazon.com/code/8720044071969977
## Please run as a user with normal privilege
## Do not use root

## Support OS: Amazon Linux 2015.09
## Script writen by Leonard Huang (lueoad@outlook.com)

cd
wget http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip
unzip CloudWatchMonitoringScripts-1.2.1.zip

cd aws-scripts-mon
mkdir -p etc/awslogs
mkdir -p opt/aws/bin
mkdir -p usr/share/doc/aws-scripts-mon-1.2.1
mkdir -p usr/local/lib64/perl5
mkdir -p etc/cron.d

mv awscreds.template etc/awslogs/awscreds.conf
mv mon-put-instance-data.pl opt/aws/bin/mon-put-instance-data
mv mon-get-instance-stats.pl opt/aws/bin/mon-get-instance-stats

mv *.txt usr/share/doc/aws-scripts-mon-1.2.1/
mv *.pm usr/local/lib64/perl5/

chmod 600 etc/awslogs/awscreds.conf
cat > etc/cron.d/aws-scripts-mon << EOF

# Version: 1.2.1-8
MAILTO=""
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

*/5 * * * * root /opt/aws/bin/mon-put-instance-data --mem-util --mem-used --mem-avail --swap-util --swap-used --disk-space-used --disk-space-avail --disk-space-util --disk-path=/ --from-cron --aws-credential-file=/etc/awslogs/awscreds.conf

EOF

cd ..
fpm -s dir -t rpm -C ./aws-scripts-mon --name aws-scripts-mon --version 1.2.1 --iteration 8amzn --depends  "perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https" --description "Amazon CloudWatch Monitoring Scripts for Linux\nhttp://aws.amazon.com/code/8720044071969977"


## Clean up

rm -rf aws-scripts-mon
rm CloudWatchMonitoringScripts-1.2.1.zip
