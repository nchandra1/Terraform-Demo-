### RESOURCE BLOCKS AND VARIABLES ###

# Create a vpc - logically isolated section of the AWS, provision resources such as instances, subnets, and sec groups. 
resource "aws_vpc" "terra_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "my_vpc"
  }
}
# Create an internet gateway -  internet gateway, which enables communication between your VPC and the internet. 
resource "aws_internet_gateway" "terra_IGW" {
  vpc_id = aws_vpc.terra_vpc.id
  tags = {
    name = "my_IGW"
  }
}
# Create a custom route table - define routing rules for your VPC. It determines how network traffic is directed between subnets and internet gateway.
resource "aws_route_table" "terra_route_table" {
  vpc_id = aws_vpc.terra_vpc.id
  tags = {
    name = "my_route_table"
  }
}
# create route- associate route with a route table. It defines the destination CIDR block and the target, such as an internet gateway or network interface.
resource "aws_route" "terra_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.terra_IGW.id
  route_table_id = aws_route_table.terra_route_table.id
}
# create a subnet -  aws_subnet resource represents a subnet within a VPC. Subnets divide the IP address range of VPC into CIDR blocks, segmentation & network traffic control.
resource "aws_subnet" "terra_subnet" {
  vpc_id = aws_vpc.terra_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone
  
  tags = {
    name = "my_subnet"
  }
}
# associate internet gateway to the route table by using subnet. associates a subnet with a route table. 
resource "aws_route_table_association" "terra_assoc" {
  subnet_id = aws_subnet.terra_subnet.id
  route_table_id = aws_route_table.terra_route_table.id
}
# create security group to allow ingoing ports - allows you to define inbound/outbound network traffic rules for your instances. virtual firewall
resource "aws_security_group" "terra_SG" {
  name        = "sec_group"
  description = "security group for the EC2 instance"
  vpc_id      = aws_vpc.terra_vpc.id
  ingress = [
    {
      description      = "https traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
      security_groups   = []
      self              = false
    },
    {
      description      = "http traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
      security_groups   = []
      self              = false
    },
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["76.251.40.229/32"]
      ipv6_cidr_blocks  = []
      prefix_list_ids   = []
      security_groups   = []
      self              = false
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Outbound traffic rule"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = {
    name = "allow_web"
  }
}

# create a network interface with private ip. network interface can be attached to EC2 instance. use it to control networking properties and sec group 
resource "aws_network_interface" "terra_net_interface" {
  subnet_id = aws_subnet.terra_subnet.id
  security_groups = [aws_security_group.terra_SG.id]
}
# assign a elastic ip to the network interface - An EIP is a static, public IP address and web server endpoint - associated with EC2 instance
resource "aws_eip" "terra_eip" {
  vpc = true
  network_interface = aws_network_interface.terra_net_interface.id
  associate_with_private_ip = aws_network_interface.terra_net_interface.private_ip
  depends_on = [aws_internet_gateway.terra_IGW, aws_instance.terra_ec2]
}
# create an ubuntu server and install/enable apache2. EC2 (Elastic Compute Cloud) VM instance, which will host our web server. 
resource "aws_instance" "terra_ec2" {
  ami = var.ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = "demo"
  
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.terra_net_interface.id
  }
  
  user_data = file("${path.module}/user_data.sh")
  
  tags = {
    name = "web_server"
  }
}
