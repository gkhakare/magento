#
# Cookbook Name:: magento
# Recipe:: default
#
# Copyright 2016, opexsoftware.com
#
# All rights reserved - Do Not Redistribute
#

#https://github.com/OpenMage/magento-mirror/releases/tag/1.9.2.4

#Copy magento apache configuration file

include_recipe "apache2"

magentoVersion = node[:magento][:version]

file '/etc/apache2/sites-available/magento.conf' do
  path 'magento.conf' 
end

bash 'extract_module' do
 
  code <<-EOH
    sudo a2ensite magento.conf
    sudo a2dissite 000-default.conf
    EOH

end

template '/etc/php5/apache2/php.ini' do
  source 'php.ini.erb'
  owner 'root'
  group 'root'
  variables({
     :mem_limit => node[:magento][:mem_limit]
  })
end

execute "apt-get-update" do
  command "sudo apt-get update -y"
  ignore_failure true
  action :run
end

%W(libcurl3 php5-curl php5-gd php5-mcrypt).each do |pkg|
  package "#{pkg}" do
     action :install
     timeout 240
     retries 2
  end
end


bash 'extract_module' do 
  code <<-EOH
	cd /tmp
  	#wget https://github.com/OpenMage/magento-mirror/archive/#{magentoVersion}.tar.gz    
	tar -xvf #{magentoVersion}.tar.gz
	rm -rf /var/www/html/*
	mv magento-mirror-#{magentoVersion}/* /var/www/html
	sudo chown -R www-data:www-data /var/www/html/
    EOH
end

template '/var/www/html/app/etc/local.xml' do
  source 'local.xml.erb'
  mode '0440'
  owner 'root'
  group 'root'
  variables({
     :dbuser => node[:magento][:dbuser],
     :dbpassword => node[:magento][:dbpass],
     :dbname => node[:magento][:dbname],
     :dbhost => node[:magento][:dbhost]
  })
end

service 'apache2' do
  action :restart
end
