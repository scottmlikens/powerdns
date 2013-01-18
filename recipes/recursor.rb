#
# Cookbook Name:: powerdns
# Recipe:: server
#
# Copyright 2009, Scott M. Likens
#

# Manual steps, run /etc/powerdns/first-run manually,
# e.g. mysql -p -f < /etc/powerdns/first-run

remote_file "/var/tmp/pdns-recursor_#{node[:powerdns][:recursor_version]}_#{node['kernel']['machine'] =~ /x86_64/ ? "amd64" : "i386"}.deb" do
  source "http://downloads.powerdns.com/releases/deb/pdns-recursor_#{node[:powerdns][:recursor_version]}_#{node['kernel']['machine'] =~ /x86_64/ ? "amd64" : "i386"}.deb"
  action :create_if_missing
end

package "pdns-recursor" do
  source "/var/tmp/pdns-recursor_#{node[:powerdns][:recursor_version]}_#{node['kernel']['machine'] =~ /x86_64/ ? "am\
d64" : "i386"}.deb"
  provider Chef::Provider::Package::Dpkg
  action :install
end

service "pdns-recursor" do
  action [:start,:enable]
end
template "/etc/powerdns/recursor.conf" do
  source "recursor.conf.erb"
  mode 0440
  backup false
  variables(
            :allow_from => ["107.6.111.0/24","172.29.21.0/24","127.0.0.0/8","10.0.0.0/8","192.168.0.0/16","172.16.0.0/12","::1/128","fe80::/10"],
            :local_address => "0.0.0.0",
            :logging_facility => "0",
            :max_mthreads => 655355,
            :max_tcp_clients => 655355,
            :socket_dir => "/var/run",
            :threads => node[:cpu][:total].to_i
            )
  notifies :restart, resources(:service => "pdns-recursor")
end

