#
# Cookbook:: mongodb_cookbook_final
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'apt'
# include_recipe 'debian'

execute 'mongod_apt_key'do
  command 'sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 4B7C549A058F8B6B'
  action :run
end

execute 'mongod_update_sourcelist' do
  command "echo 'deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb.list"
  action :run
end

execute 'apt-update' do
  command 'sudo apt-get update -y'
  action :run
end

execute 'mongodb_install' do
  command 'sudo apt install mongodb-org=4.2.1 mongodb-org-server=4.2.1 mongodb-org-shell=4.2.1 mongodb-org-mongos=4.2.1 mongodb-org-tools=4.2.1'
  action :run
end


service 'mongod' do
  action [:enable, :start]
end

template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  variables bind_ip: node['mongod']['bind_ip'], port: node['mongod']['port']
  notifies :restart, 'service[mongod]'
end

template '/lib/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  action :create
  notifies :restart, 'service[mongod]'
end
