Feature: Install rsnapshot backup tool and configure it to back up critical data
	
	Background:
		Given that I have a running server
		And I provision it

	Scenario:
		When I install rsnapshot
		Then it should be successful
		And the config file should exist

	Scenario:
		When I configure rsnapshot
		Then it should be successful
		And running configtest should return OK

	Scenario:
		When I run a backup task
		Then it should be successful
		And my backup directories and files should be the same as the source

	Scenario:
		When I setup backup cron jobs
		Then it should be successful
		And crontab should contain my list of jobs