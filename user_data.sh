#!/bin/bash
# Executed when an EC2 instance is launched
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2

sudo bash -c 'cat <<EOT > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Web Server on AWS</title>
  <style>
    body {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      font-family: Arial, sans-serif;
    }
    img {
      margin: 20px 0;
      max-width: 80%;
      height: auto;
    }
    a {
      margin-top: 20px;
      color: blue;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <h1>Deploy a Web Server on AWS</h1>
  <img src="https://imgur.com/a/ZVbjyiV" alt="Terraform Cloud">
  <a href="https://app.terraform.io/app/organizations" target="_blank">Let's discover the value of Terraform Cloud!</a>
</body>
</html>
EOT'
