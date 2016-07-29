Feature: Install AWS CLI and setup automatic upload of backups

	Background:
		Given that I have a running server
		And I provision it

	Scenario:
		When I install AWS CLI
		Then it should be successful
		And running 'aws --version' should return a version number

	Scenario:
		When I upload the backup folder
		Then it should be successful
		And the command should return an OK status

	Scenario:
		When I create an AWS S3 bucket cron job
		Then it should be successful
		And 'cat /etc/cron.d' should return the cron file