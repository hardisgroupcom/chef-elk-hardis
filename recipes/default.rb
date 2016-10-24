#
# Cookbook Name:: elk-hardis
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


include_recipe 'elk-hardis::utils'
include_recipe 'elk-hardis::redis'
include_recipe 'elk-hardis::logstash'
include_recipe 'elk-hardis::elasticsearch'
include_recipe 'elk-hardis::kibana'
include_recipe 'elk-hardis::grafana'
include_recipe 'elk-hardis::influxdb'
include_recipe 'elk-hardis::config'