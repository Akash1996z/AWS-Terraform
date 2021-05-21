provider "aws" {
   region   = "us-east-2"
}

#============================================================================================= PROVIDER

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

#=============================================================================================== INTERNET GATEWAYS

#resource "aws_eip" "eip" {
#   vpc=true
#}

#resource "aws_nat_gateway" "ngw" {
#   allocation_id = aws_eip.eip.id
#   subnet_id = aws_subnet.subnet-p.id
#
#    tags = {
#     Name = "ngw"
#   }
#}

#===============================================================================================

resource "aws_route_table" "public-route-1" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }

#   route {
#   ipv6_cidr_block = "::/0"
#   egress_only_gateway_id = aws_egress_only_internet_gateway.igw.id
#   }

   tags = {
      Name = "public-route-1"
   }
}  

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   

resource "aws_route_table" "public-route-2" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }

#   route {
#   ipv6_cidr_block = "::/0"
#   egress_only_gateway_id = aws_egress_only_internet_gateway.igw.id
#   }

   tags = {
      Name = "public-route-2"
   }
}  

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#resource "aws_default_route_table" "public-route-default" {
#   default_route_table_id = "aws_vpc.main.default_route_table_id"
#   
#   tags = {
#      Name = "public-route-default"
#   }
#}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

resource "aws_route_table" "private-route-app-1" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }

#   route {
#   ipv6_cidr_block = "::/0"
#   egress_only_gateway_id = aws_egress_only_internet_gateway.igw.id
#   }

   tags = {
      Name = "private-route-app-1"
   }
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

resource "aws_route_table" "private-route-app-2" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }

#   route {
#   ipv6_cidr_block = "::/0"
#   egress_only_gateway_id = aws_egress_only_internet_gateway.igw.id
#   }

   tags = {
      Name = "private-route-app-2"
   }
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

resource "aws_route_table" "private-route-data-1" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }

#   route {
#   ipv6_cidr_block = "::/0"
#   egress_only_gateway_id = aws_egress_only_internet_gateway.igw.id
#   }

   tags = {
      Name = "private-route-data-1"
   }
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

resource "aws_route_table" "private-route-data-2" {
   vpc_id = aws_vpc.main.id

   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }

#   route {
#   ipv6_cidr_block = "::/0"
#   egress_only_gateway_id = aws_egress_only_internet_gateway.igw.id
#   }

   tags = {
      Name = "private-route-data-2"
   }
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#=============================================================================================== ROUTE TABLES

resource "aws_route_table_association" "pub-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-1.id
}

resource "aws_route_table_association" "pub-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-2.id
}

resource "aws_route_table_association" "pri-app-1" {
  subnet_id      = aws_subnet.app-subnet-1.id
  route_table_id = aws_route_table.private-route-app-1.id
}

resource "aws_route_table_association" "pri-app-2" {
  subnet_id      = aws_subnet.app-subnet-2.id
  route_table_id = aws_route_table.private-route-app-2.id
}

resource "aws_route_table_association" "pri-data-1" {
  subnet_id      = aws_subnet.data-subnet-1.id
  route_table_id = aws_route_table.private-route-data-1.id
}

resource "aws_route_table_association" "pri-data-2" {
  subnet_id      = aws_subnet.data-subnet-2.id
  route_table_id = aws_route_table.private-route-data-2.id
}

#=============================================================================================== ROUTE_TABLE_ASSOCIATION


resource "aws_security_group" "ssh-pub-1" {
   name = "ssh-pub-1"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
 #     ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
   }
 
   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = ["::/0"]
   }

   tags = {
      Name = "ssh-pub-1"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_PUB-1

resource "aws_security_group" "ssh-pub-2" {
   name = "ssh-pub-2"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
 #     ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
   }
 
   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = ["::/0"]
   }

   tags = {
      Name = "ssh-pub-2"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_PUB-2

resource "aws_security_group" "ssh-app-1" {
   name = "ssh-app-1"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["10.0.1.0/28"]
 #     ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
   }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = ["::/0"]
   }

   tags = {
      Name = "ssh-app-1"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_APP-1

resource "aws_security_group" "ssh-app-2" {
   name = "ssh-app-2"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["10.0.2.0/28"]
 #     ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
   }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = ["::/0"]
   }

   tags = {
      Name = "ssh-app-2"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_APP-2

resource "aws_security_group" "ssh-data-1" {
   name = "ssh-data-1"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["10.0.3.0/28"]
 #     ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
   }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = ["::/0"]
   }

   tags = {
      Name = "ssh-data-1"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_DATA-1

resource "aws_security_group" "ssh-data-2" {
   name = "ssh-data-2"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["10.0.4.0/28"]
 #     ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
   }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
#      ipv6_cidr_blocks = ["::/0"]
   }

   tags = {
      Name = "ssh-data-2"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SG_DATA-2

#resource "aws_network_interface" "instance-pub" {
#   subnet_id = aws_subnet.subnet-p.id

#   tags = {
#      Name = "network_instance-pub"
#   }
#}

#resource "aws_network_interface" "instance-pri" {
#   subnet_id = aws_subnet.subnet-pi.id

#   tags = {
#      Name = "network_instance-pri"
#   }
#}
#=========================================================================================== SECURITY GROUPS

resource "aws_instance" "instance-pub-1" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   key_name = "terraform"
   vpc_security_group_ids = [aws_security_group.ssh-pub-1.id]
   subnet_id = aws_subnet.public-subnet-1.id 
   associate_public_ip_address = true

#   network_interface {
#      network_interface_id = aws_network_interface.instance-pub.id
#      device_index = 0
#   } 

   tags = {
      Name = "instance-pub-1"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_PUB-1

resource "aws_instance" "instance-pub-2" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   key_name = "terraform"
   vpc_security_group_ids = [aws_security_group.ssh-pub-2.id]
   subnet_id = aws_subnet.public-subnet-2.id 
   associate_public_ip_address = true

#   network_interface {
#      network_interface_id = aws_network_interface.instance-pub.id
#      device_index = 0
#   } 

   tags = {
      Name = "instance-pub-2"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_PUB-2

resource "aws_instance" "instance-app-1" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.ssh-app-1.id]
   subnet_id = aws_subnet.app-subnet-1.id 
   key_name = "terraform"
#   key_name = "id_rsa"

#   network_interface {
#      network_interface_id = aws_network_interface.instance-pri.id
#      device_index = 0
#   }  

   tags = {
      Name = "instance-app-1"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_APP-1

resource "aws_instance" "instance-app-2" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.ssh-app-2.id]
   subnet_id = aws_subnet.app-subnet-2.id 
   key_name = "terraform"
#   key_name = "id_rsa"

#   network_interface {
#      network_interface_id = aws_network_interface.instance-pri.id
#      device_index = 0
#   }  

   tags = {
      Name = "instance-app-2"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_APP-2

resource "aws_instance" "instance-data-1" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.ssh-data-1.id]
   subnet_id = aws_subnet.data-subnet-1.id 
   key_name = "terraform"
#   key_name = "id_rsa"

#   network_interface {
#      network_interface_id = aws_network_interface.instance-pri.id
#      device_index = 0
#   }  

   tags = {
      Name = "instance-data-1"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_DATA-1

resource "aws_instance" "instance-data-2" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.ssh-data-2.id]
   subnet_id = aws_subnet.data-subnet-2.id 
   key_name = "terraform"
#   key_name = "id_rsa"

#   network_interface {
#      network_interface_id = aws_network_interface.instance-pri.id
#      device_index = 0
#   }  

   tags = {
      Name = "instance-data-2"
   }
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ INS_DATA-2

#resource "aws_key_pair" "key_pair" {
#   key_name = "id_rsa"
#   public_key = ""
#}

#=============================================================================================== INSTANCES

output "public_ip-1" {
  value       = aws_instance.instance-pub-1.public_ip
  description = "The public IP of the web server"
}

output "public_ip-2" {
  value       = aws_instance.instance-pub-2.public_ip
  description = "The public IP of the web server"
}
