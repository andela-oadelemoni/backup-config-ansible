# Backup Configuration with Ansible

Set up periodic backups on your server with [rsnapshot](http://rsnapshot.org/). This playbook was written to be dynamic and flexible. All you have to do is specify the key services you would like to backup and the folders will be automatically added to the backup tasks including default folders such as:
* /home/
* /etc/
* /usr/local

This script was written for Debian distribution and tested on `Ubuntu 14.04.4 LTS` server.

**To get started:**
###### 1. Open `hosts.ini` file in the playbooks directory and enter your host name(s) with DNS name or IP address. Also enter path to ssh key file

```
[hostname]
# Enter IP Address or DNS name e.g www.example.com and path to key file like this:
# 10.10.10.10 ansible_ssh_private_key_file=<path to key file>
```
###### 2. Open `config_vars.yml` in playbooks directory and enter the required variables like this:
```ruby
# Playbook configuration
hosts: hostname # same value entered above 
user: username # ssh user

# Supported services to backup
# Uncomment each line of the services you would like to backup
# MYSQL: mysql 
```

### Running Playbook with Cucumber
To run the playbook with Cucumber BDD Test, run

```sh
$ cucumber features/setup.feature
```
This installs and configures rsnapshot on the server.

To automate the backup process and move backup files to AWS S3, create a `credentials.yml` file in playbooks directory with the following content:
```ruby
aws_key: <aws access key>
aws_secret: <aws secret key>
```
*Note that this file should NOT be public*

Next, open `aws_config_vars.yml` file in playbooks directory and edit the file like below:
```ruby
aws_region: <aws region>
# The default backup directory for rsnapshot is /var/cache/rsnapshot. If you have manually changed this, you might need to change it here as well.
backup_directory: /var/cache/rsnapshot 
# Note that if bucket doesn't exist, the playbook will attempt to create one with the name given below (provided it is unique of course)
s3_bucket_name: <S3 bucket name> 
```
Next, run
```sh
cucumber features/aws_setup.feature
```
To modify how frequent your backups should be pushed to AWS S3, you can open `aws_s3_cron.j2` file in `playbooks/roles/s3-bucket/templates` directory and modify the cron task as desired.

*If you don't have cucumber installed, visit [cucumber.io](https://cucumber.io/) for installation guide.*

### Running Playbook Directly

To run playbook directly without cucumber, run

```sh
$ ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml
```
to set up rsnapshot on your server.

To automate the backup process with cron jobs, follow the AWS configuration steps above and run
```sh
$ ansible-playbook -i playbooks/hosts.ini playbooks/s3-bucket.yml
```

***Happy Configuring :)***
