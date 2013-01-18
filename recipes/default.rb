#
# Cookbook Name:: powerdns
# Recipe:: default
#
# Copyright 2009, Scott M. Likens.
#

group "pdns" do
end

user "pdns" do
  comment "powerdns user"
  gid "pdns"
  home "/var/empty"
  supports :manage_home => false
  shell "/sbin/nologin"
end


