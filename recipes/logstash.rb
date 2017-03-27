#
# Cookbook Name:: elk-hardis
# Recipe:: logstash
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'elk-hardis::user'
include_recipe 'elk-hardis::java'


rpm_name = 'logstash-2.4.0.noarch.rpm'
rpm_url = 'https://download.elastic.co/logstash/logstash/packages/centos/logstash-2.4.0.noarch.rpm'

remote_file "#{node['elk-hardis']['rpm_path']}/#{rpm_name}" do
  source rpm_url
  not_if { ::File.exists?("#{node['elk-hardis']['rpm_path']}/#{rpm_name}") }
end


rpm_package rpm_name do
        source "#{node['elk-hardis']['rpm_path']}/#{rpm_name}"
end


template '/etc/logstash/conf.d/output.logstash.conf' do
    source 'logstash/output.logstash.conf.erb'
    mode '0644'
    owner 'elk'
    group 'elk'
    notifies :restart, 'service[logstash]'
end


##SERVICE##
service 'logstash' do
  supports status: true, restart: true
  action [:enable, :restart]
end
##END SERVICE##
