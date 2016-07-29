require 'open3'


Given(/^that I have a running server$/) do
  output, error, status = Open3.capture3 "vagrant reload"
  expect(status.success?).to eq(true)
end

Given(/^I provision it$/) do
  output, error, status = Open3.capture3 "vagrant provision"
  expect(status.success?).to eq(true)
end

When(/^I install dependencies$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml --tags 'commmon'"
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I install rsnapshot$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml --tags 'install'"
  output, error, @status = Open3.capture3 "#{command}"
end

Then(/^it should be successful$/) do
  expect(@status.success?).to eq(true)
end

And(/^the config file should exist$/) do
  expect(@status.success?).to eq(true)
end

When(/^I configure rsnapshot$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml --tags 'configure'"
  output, error, @status = Open3.capture3 "#{command}"
end

And(/^running configtest should return OK$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml --tags 'configuration-test'"
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
end

When(/^I run a backup task$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml --tags 'backup-test'"
  output, error, @status = Open3.capture3 "#{command}"
end

And(/^my backup directories and files should be the same as the source$/) do
	command = "ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml --tags 'backup-verify'"
	output, error, status = Open3.capture3 "#{command}"

	expect(status.success?).to eq(true)
end

When(/^I setup backup cron jobs$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml --tags 'cron-setup'"
  output, error, @status = Open3.capture3 "#{command}"
end

Then(/^crontab should contain my list of jobs$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/rsnapshot.yml --tags 'cron-check'"
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
end