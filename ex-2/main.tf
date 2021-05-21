provider "aws" {
   region   = "us-east-2"
}

resource "aws_vpc" "main" {
   cidr_block = "10.0.0.0/20"
   instance_tenancy = "default"
   enable_dns_hostnames = true

   tags = {
      Name = "main"
   }
}

resource "aws_subnet" "subnet-p" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/28"
     
  tags = {
     Name = "subnet-p"
  }
}

resource "aws_subnet" "subnet-pi" {
   vpc_id = aws_vpc.main.id
   cidr_block = "10.0.2.0/28"

   tags = {
     Name= "subnet-pi"
   }
}

resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.main.id

   tags = {
      Name = "igw"
   }
}

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

resource "aws_route_table" "public-route" {
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
      Name = "public-route"
   }
}     


#resource "aws_default_route_table" "public-route-default" {
#   default_route_table_id = "aws_vpc.main.default_route_table_id"
#   
#   tags = {
#      Name = "public-route-default"
#   }
#}

resource "aws_route_table" "private-route" {
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
      Name = "private-route"
   }
}

resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.subnet-p.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "pri" {
  subnet_id      = aws_subnet.subnet-pi.id
  route_table_id = aws_route_table.private-route.id
}


resource "aws_security_group" "ssh-p" {
   name = "ssh-p"
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
      Name = "ssh-p"
   }
}

resource "aws_security_group" "ssh-pi" {
   name = "ssh-pi"
   description = "Allow SSH inbound traffic"
   vpc_id = aws_vpc.main.id

   ingress {
      description = "SSH from VPC"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [aws_vpc.main.cidr_block]
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
      Name = "ssh-pi"
   }
}

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

resource "aws_instance" "instance-pub" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   key_name = "terraform"
   vpc_security_group_ids = [aws_security_group.ssh-p.id]
   subnet_id = aws_subnet.subnet-p.id 
   associate_public_ip_address = true

#   network_interface {
#      network_interface_id = aws_network_interface.instance-pub.id
#      device_index = 0
#   } 

   tags = {
      Name = "instance-pub"
   }
}

resource "aws_instance" "instance-pri" {
   ami = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.ssh-pi.id]
   subnet_id = aws_subnet.subnet-pi.id 
   key_name = "terraform"
#   key_name = "id_rsa"

#   network_interface {
#      network_interface_id = aws_network_interface.instance-pri.id
#      device_index = 0
#   }  

   tags = {
      Name = "instance-pri"
   }
}

#resource "aws_key_pair" "key_pair" {
#   key_name = "id_rsa"
#   public_key = ""
#}

output "public_ip" {
  value       = aws_instance.instance-pub.public_ip
  description = "The public IP of the web server"
}
