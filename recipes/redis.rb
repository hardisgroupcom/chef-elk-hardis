#
# Cookbook Name:: elk-hardis
# Recipe:: redis
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


directory '/root/elk_install/rpm' do
    recursive true
end


rpm_name = 'redis-3.2.1-1.el7.centos.x86_64.rpm'
#On pousse le rpm
cookbook_file "/root/elk_install/rpm/#{rpm_name}" do
    source "rpms/#{rpm_name}"
end

#On install le package
rpm_package rpm_name do
    source "/root/elk_install/rpm/#{rpm_name}"
end

#On crée le repertoire de conf
directory '/etc/redis' do
    owner 'redis'
    group 'redis'
end

fichier_conf_custo = '/etc/redis-hardis.conf'

#On crée le fichier de configuration
template '/etc/redis.conf' do
    source 'redis.conf.erb'
    mode '0644'
    owner 'redis'
    group 'redis'
    variables({
        #Avec un include vers un fichier custo
        :conf_custo => fichier_conf_custo
    })
    notifies :restart, 'service[redis]'
end

redis_home = '/var/lib/redis/'

#On crée le fichier custo
template fichier_conf_custo do
    source 'redis-hardis.conf.erb'
    mode '0644'
    owner 'redis'
    group 'redis'
    variables({
        :redis_ip => '0.0.0.0',
        :redis_home => redis_home,
        :redis_password => node['elk-hardis']['redis_password']
    })
    notifies :restart, 'service[redis]'
end


##SERVICE##
service 'redis' do
  supports status: true, restart: true
  action [:enable, :start]
end
##END SERVICE##
