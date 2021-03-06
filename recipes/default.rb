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

execute "apt-get-update" do
  command "sudo apt-get update -y"
  ignore_failure true
  action :run
end




include_recipe "apache2::default"
include_recipe "apache2::mod_php5"


%W(libcurl3 php5-curl php5-gd php5-mcrypt libapache2-mod-auth-mysql php5-mysql).each do |pkg|
  package "#{pkg}" do
     action :install
     timeout 240
     retries 2
  end
end


magentoVersion = node[:magento][:version]

cookbook_file '/etc/apache2/sites-available/magento.conf' do
  source 'magento.conf' 
end

bash 'extract_module' do
 
  code <<-EOH
    a2ensite magento.conf
    
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

bash 'Load mycrypt module' do 
  code <<-EOH
	php5enmod mcrypt
	service apache2 restart
    EOH
end



bash 'Install magento application' do 
  code <<-EOH
	cd /tmp
  	wget https://github.com/speedupmate/Magento-CE-Mirror/archive/magento-ce-#{magentoVersion}.tar.gz
	tar -xvf magento-ce-#{magentoVersion}.tar.gz
	rm -rf /var/www/html/*
	mv Magento-CE-Mirror-magento-ce-#{magentoVersion}/* /var/www/html
	sudo chown -R www-data:www-data /var/www/html/
    EOH
end




service 'apache2' do
  action :restart
end
