#
# Cookbook:: task4_nginx
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'nginx' do
  action :install
end

lb 'nginx_server' do
  role "nginx_server"
  action :detach
end

lb 'apache_server' do
  role "apache_server"
  action :attach
end

lb 'jboss_server' do
  role "jboss_server"
  action :attach
end

service 'nginx' do
  action [ :enable, :start ]
  supports :reload => true
end

