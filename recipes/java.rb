rpm_name = 'jdk-8u144-linux-x64.rpm'
rpm_url = 'http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.rpm'

remote_file "#{node['elk-hardis']['rpm_path']}/#{rpm_name}" do
  source rpm_url
  headers({ "Cookie" => "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" })
  not_if { ::File.exists?("#{node['elk-hardis']['rpm_path']}/#{rpm_name}") }
end


rpm_package rpm_name do
        source "#{node['elk-hardis']['rpm_path']}/#{rpm_name}"
end
