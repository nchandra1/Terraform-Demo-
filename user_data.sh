#!/bin/bash
#executed when an EC2 instance is launched
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
echo "<h1> Deploy a web server on AWS </h1>" | sudo tee /var/www/html/index.html