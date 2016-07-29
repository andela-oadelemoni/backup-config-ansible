require 'open3'

When(/^I install dependencies$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/s3-bucket.yml --tags 'dependencies'"
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I install AWS CLI$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/s3-bucket.yml --tags 'install'"
  output, error, @status = Open3.capture3 "#{command}"
end

Then(/^running 'aws \-\-version' should return a version number$/) do
  command = "vagrant ssh -c 'aws --version'"
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
end

When(/^I create S3 bucket$/) do
	command = "ansible-playbook -i playbooks/hosts.ini playbooks/s3-bucket.yml --tags 'create-bucket'"
	output, error, @status = Open3.capture3 "#{command}"
end

And(/^my newly created bucket should be available$/) do
	command = "ansible-playbook -i playbooks/hosts.ini playbooks/s3-bucket.yml --tags 'confirm-bucket'"
	output, error, status = Open3.capture3 "#{command}"

	expect(status.success?).to eq(true)
end

When(/^I upload the backup folder$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/s3-bucket.yml --tags 'upload'"
	output, error, @status = Open3.capture3 "#{command}"
end

Then(/^the command should return an OK status$/) do
  expect(@status.success?).to eq(true)
end

When(/^I create an AWS S(\d+) bucket cron job$/) do |arg1|
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/s3-bucket.yml --tags 'cron-setup'"
	output, error, @status = Open3.capture3 "#{command}"
end

Then(/^'cat \/etc\/cron\.d' should return the cron file$/) do
  command = "ansible-playbook -i playbooks/hosts.ini playbooks/s3-bucket.yml --tags 'cron-check'"
	output, error, status = Open3.capture3 "#{command}"

	expect(status.success?).to eq(true)
end
