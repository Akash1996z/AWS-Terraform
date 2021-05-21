provider "aws" {
   region   = "us-east-2"
}

#============================================================================================== PROVIDER

resource "aws_vpc" "main" {
   cidr_block = "10.0.0.0/20"
   instance_tenancy = "default"
   enable_dns_hostnames = true

   tags = {
      Name = "main"
   }
}

#=============================================================================================== VPC

resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/28"
     
  tags = {
     Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/28"
     
  tags = {
     Name = "public-subnet-2"
  }
}

resource "aws_subnet" "app-subnet-1" {
   vpc_id = aws_vpc.main.id
   cidr_block = "10.0.3.0/28"

   tags = {
     Name= "app-subnet-1"
   }
}

resource "aws_subnet" "app-subnet-2" {
   vpc_id = aws_vpc.main.id
   cidr_block = "10.0.4.0/28"

   tags = {
     Name= "app-subnet-2"
   }
}

resource "aws_subnet" "data-subnet-1" {
   vpc_id = aws_vpc.main.id
   cidr_block = "10.0.5.0/28"

   tags = {
     Name= "data-subnet-1"
   }
}

resource "aws_subnet" "data-subnet-2" {
   vpc_id = aws_vpc.main.id
   cidr_block = "10.0.6.0/28"

   tags = {
     Name= "data-subnet-2"
   }
}

#=============================================================================================== SUBNETS

resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.main.id

   tags = {
      Name = "igw"
   }
}

#=============================================================================================== INTERNET GATEWAY

resource "aws_eip" "eip-1" {
   vpc=true
}

resource "aws_eip" "eip-2" {
   vpc=true
}

#=============================================================================================== EIP

resource "aws_nat_gateway" "ngw-1" {
   allocation_id = aws_eip.eip-1.id
   subnet_id = aws_subnet.public-subnet-1.id

    tags = {
     Name = "ngw-1"
   }
}

resource "aws_nat_gateway" "ngw-2" {
   allocation_id = aws_eip.eip-2.id
   subnet_id = aws_subnet.public-subnet-2.id

    tags = {
     Name = "ngw-2"
   }
}

#===============================================================================================

resource "aws_route_table" "public-route" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }

   tags = {
      Name = "public-route"
   }
}  

resource "aws_route_table" "private-route-1" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.ngw-1.id
   }

   tags = {
      Name = "private-route-1"
   }
}

resource "aws_route_table" "private-route-2" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.ngw-2.id
   }

   tags = {
      Name = "private-route-2"
   }
}

#=============================================================================================== ROUTE TABLES

resource "aws_route_table_association" "pub-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "pub-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "pri-app-1" {
  subnet_id      = aws_subnet.app-subnet-1.id
  route_table_id = aws_route_table.private-route-1.id
}

resource "aws_route_table_association" "pri-app-2" {
  subnet_id      = aws_subnet.app-subnet-2.id
  route_table_id = aws_route_table.private-route-2.id
}

resource "aws_route_table_association" "pri-data-1" {
  subnet_id      = aws_subnet.data-subnet-1.id
  route_table_id = aws_route_table.private-route-1.id
}

resource "aws_route_table_association" "pri-data-2" {
  subnet_id      = aws_subnet.data-subnet-2.id
  route_table_id = aws_route_table.private-route-2.id
}

#=============================================================================================== ROUTE_TABLE_ASSOCIATION


resource "aws_security_group" "ssh-pub" {
   name = "ssh-pub"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
 
   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
      Name = "ssh-pub"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_PUB

resource "aws_security_group" "ssh-app" {
   name = "ssh-app"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["10.0.1.0/28"]
   }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
      Name = "ssh-app"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_APP

resource "aws_security_group" "ssh-data" {
   name = "ssh-data-1"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["10.0.3.0/28"]
   }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
      Name = "ssh-data"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_DATA

#=========================================================================================== SECURITY GROUPS

resource "aws_instance" "instance-pub" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   key_name = "terraform"
   vpc_security_group_ids = [aws_security_group.ssh-pub.id]
   subnet_id = aws_subnet.public-subnet-1.id 
   associate_public_ip_address = true

   tags = {
      Name = "instance-pub"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_PUB

resource "aws_instance" "instance-app" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.ssh-app.id]
   subnet_id = aws_subnet.app-subnet-1.id 
   key_name = "terraform"

   tags = {
      Name = "instance-app"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_APP

resource "aws_instance" "instance-data" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.ssh-data.id]
   subnet_id = aws_subnet.data-subnet-1.id 
   key_name = "terraform"

   tags = {
      Name = "instance-data"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_DATA

#=============================================================================================== INSTANCES

output "public_ip" {
  value       = aws_instance.instance-pub.public_ip
  description = "The public IP of the web server"
}

