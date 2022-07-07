#!/usr/bin/bash

yum update -y
#install apache server and mysql client
yum install -y httpd
yum install -y mysql


#first enable php7.xx from  amazon-linux-extra and install it

amazon-linux-extras enable php7.4
yum clean metadata
yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}
#install imagick extension
yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
yes ' ' |pecl install imagick
chmod 755 /usr/lib64/php/modules/imagick.so
cat <<EOF >>/etc/php.d/20-imagick.ini
extension=imagick
EOF

systemctl restart php-fpm.service




systemctl start  httpd


# Change OWNER and permission of directory /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Download wordpress package and extract
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
# Change permission of /var/www/html/
chown -R ec2-user:apache /var/www/html
chmod -R 774 /var/www/html

#Make apache and mysql to autostart and restart apache
systemctl enable  httpd.service
systemctl restart httpd.service