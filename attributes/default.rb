default[:magento][:version] = '1.9.2.4'
default[:magento][:dir] = '/var/www/magento'
default[:magento][:domain] = node['fqdn']
# Magento CE's sample data can be found here:
# 'http://www.magentocommerce.com/downloads/assets/1.9.0.0/magento-sample-dat'\
# 'a-1.9.0.0.tar.gz'
# If you are using a version of Magento Community Edition older than 1.9.0.0,
# you will need to use a version of sample data that is compatible with your
# version.
default[:magento][:mem_limit] = '512M'
default[:magento][:dbhost] = 'localhost:3360'
default[:magento][:dbuser] = 'root'
default[:magento][:dbpassword] = 'root'
default[:magento][:dbname] = 'magento'

