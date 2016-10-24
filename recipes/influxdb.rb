#
# Cookbook Name:: elk-hardis
# Recipe:: influxdb
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


include_recipe 'elk-hardis::user'

rpm_name = 'influxdb-1.0.2.x86_64.rpm'
rpm_url = 'https://dl.influxdata.com/influxdb/releases/influxdb-1.0.2.x86_64.rpm'

remote_file "#{node['elk-hardis']['rpm_path']}/#{rpm_name}" do
  source rpm_url
  not_if { ::File.exists?("#{node['elk-hardis']['rpm_path']}/#{rpm_name}") }
end

rpm_package rpm_name do
    source "#{node['elk-hardis']['rpm_path']}/#{rpm_name}"
end

#Configuration influxdb
template '/etc/influxdb/influxdb.conf' do 
    source 'influxdb.conf.erb'
    mode '0644'
    owner 'influxdb'
    group 'influxdb'
end

directory '/usr/share/collectd/'do
    action :create
    owner 'influxdb'
    group 'influxdb'
end


#Configuration types.db
template '/usr/share/collectd/types.db' do 
    source 'influxdb.types.db.erb'
    mode '0644'
    owner 'influxdb'
    group 'influxdb'
end


#On démare le service
service 'influxdb' do
      action [:enable, :restart]
end



