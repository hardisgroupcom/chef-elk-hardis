#
# Cookbook Name:: elk-hardis
# Recipe:: utils
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


list_packages = %w[vim tmux wget curl]


list_packages.each do |package_name|
   package package_name
end


directory node['elk-hardis']['rpm_path'] do
    recursive true
end