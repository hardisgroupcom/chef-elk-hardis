#
# Cookbook Name:: elk-hardis
# Recipe:: kibana
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


include_recipe 'elk-hardis::user'




rpm_name = 'kibana-4.6.1-x86_64.rpm'
rpm_url = 'https://download.elastic.co/kibana/kibana/kibana-4.6.1-x86_64.rpm'

remote_file "#{node['elk-hardis']['rpm_path']}/#{rpm_name}" do
  source rpm_url
  not_if { ::File.exists?("#{node['elk-hardis']['rpm_path']}/#{rpm_name}") }
end

rpm_package rpm_name do
        source "#{node['elk-hardis']['rpm_path']}/#{rpm_name}"
end

template '/opt/kibana/config/kibana.yml' do
    source 'kibana.yml.erb'
    mode '0644'
    owner 'elk'
    group 'elk'
    notifies :restart, 'service[kibana]'
end


##SERVICE##
service 'kibana' do
  supports status: true, restart: true
  action [:enable, :start]
end
##END SERVICE##
