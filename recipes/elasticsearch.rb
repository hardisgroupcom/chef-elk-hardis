#
# Cookbook Name:: elk-hardis
# Recipe:: elasticsearch
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


include_recipe 'elk-hardis::user'
include_recipe 'elk-hardis::java'

directory '/root/elk_install/rpm' do
    recursive true
end




rpm_name = 'elasticsearch-2.4.1.rpm'
rpm_url = 'https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.4.1/elasticsearch-2.4.1.rpm'

remote_file "#{node['elk-hardis']['rpm_path']}/#{rpm_name}" do
  source rpm_url
  not_if { ::File.exists?("#{node['elk-hardis']['rpm_path']}/#{rpm_name}") }
end

rpm_package rpm_name do
        source "#{node['elk-hardis']['rpm_path']}/#{rpm_name}"
end

list_rpm = %w[elasticsearch-curator-4.1.2-1.x86_64.rpm]

list_rpm.each do |rpm_name|
    cookbook_file "/root/elk_install/rpm/#{rpm_name}" do
        source "rpms/#{rpm_name}"
    end
    rpm_package rpm_name do
        source "/root/elk_install/rpm/#{rpm_name}"
    end
end


directory '/var/lib/elk/curator_scripts' do
    owner 'elk'
    group 'elk'
end

template '/etc/elasticsearch/elasticsearch.yml' do 
    source 'elasticsearch.yml.erb'
    mode '0644'
    owner 'elk'
    group 'elk'
end


template '/var/lib/elk/curator_scripts/purge.curator.yml' do 
    source 'purge.curator.yml.erb'
    mode '0644'
    owner 'elk'
    group 'elk'
    variables({
        :retention_days_number => node['elk-hardis']['retention_days_number']
    })
end

template '/var/lib/elk/curator_scripts/localhost.curator.yml' do 
    source 'localhost.curator.yml.erb'
    mode '0644'
    owner 'elk'
    group 'elk'
end


cron 'purge elasticsearch' do
  minute '0'
  user 'elk'
  command 'curator --config /var/lib/elk/curator_scripts/localhost.curator.yml /var/lib/elk/curator_scripts/purge.curator.yml'
end


execute 'add elasticsearch head plugin' do
   command '/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head'
   not_if do FileTest.directory?('/usr/share/elasticsearch/plugins/head') end
end


service 'elasticsearch' do
  action [:enable, :restart]
end
