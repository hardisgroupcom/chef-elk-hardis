#
# Cookbook Name:: elk-hardis
# Recipe:: user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


elk_user = 'elk' 

group elk_user

user elk_user do
  comment 'elk user system'
  system true
  group elk_user
  shell '/bin/false'
  home '/var/lib/elk/'
end

directory '/var/lib/elk' do
    owner 'elk'
    group 'elk'
end