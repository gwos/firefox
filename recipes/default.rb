#
# Cookbook Name:: automation
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/home/#{node["firefox"]["user"]}/#{node["firefox"]["source_file"]}" do
    source node["firefox"]["download_url"]
    owner node["firefox"]["user"]
    group node["firefox"]["group"]
    mode "0644"
    action :create_if_missing
end

bash "extract firefox" do
    not_if {File.exists?('/home/#{node["firefox"]["user"]}/firefox')}
    user node["firefox"]["user"]
    cwd "/home/#{node["firefox"]["user"]}"
    code <<-EOH
        tar xvf #{node["firefox"]["source_file"]}
    EOH
end

template "/home/#{node["firefox"]["user"]}/firefox/mozilla.cfg" do
    source "mozilla.cfg.erb"
    owner node["firefox"]["user"]
    group node["firefox"]["group"]
    mode "0644"
end

template "/home/#{node["firefox"]["user"]}/firefox/defaults/pref/local-settings.js" do
    source "local-settings.js.erb"
    owner node["firefox"]["user"]
    group node["firefox"]["group"]
    mode "0644"
end

bash "move firefox to path" do
    user "root"
    cwd "/home/#{node["firefox"]["user"]}"
    code <<-EOH
        mv firefox /usr/bin/firefox-15
        ln -s /usr/bin/firefox-15/firefox /usr/bin/firefox
    EOH
end