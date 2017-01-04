#
# Cookbook Name:: elk-hardis
# Recipe:: grafana
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


include_recipe 'elk-hardis::user'

#On installe les dépendances
 deps = %w(initscripts fontconfig)
 deps.each do |pkg|
    package pkg
 end

rpm_name = 'grafana-4.0.2-1481203731.x86_64.rpm'
rpm_url = 'https://grafanarel.s3.amazonaws.com/builds/grafana-4.0.2-1481203731.x86_64.rpm'

remote_file "#{node['elk-hardis']['rpm_path']}/#{rpm_name}" do
  source rpm_url
  not_if { ::File.exists?("#{node['elk-hardis']['rpm_path']}/#{rpm_name}") }
end

rpm_package rpm_name do
    source "#{node['elk-hardis']['rpm_path']}/#{rpm_name}"
end

#Configuration grafana
template '/etc/grafana/grafana.ini' do 
    source 'grafana.ini.erb'
    mode '0644'
    owner 'grafana'
    group 'grafana'
end

directory '/var/lib/grafana/dashboards' do
    owner 'grafana'
    group 'grafana'
end

#On démare les services
service 'grafana-server' do
      action [:enable, :restart]
end




