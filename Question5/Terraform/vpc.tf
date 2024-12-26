### VPC ###

resource "aws_vpc" "main" {

 cidr_block = "10.0.0.0/16"
 tags       = {
   Name = "Assignment VPC"
 }
}

resource "aws_internet_gateway" "gw" {

 vpc_id = aws_vpc.main.id
 tags   = {
   Name = "Assignment VPC IG"
 }
}

resource "aws_route_table" "second_rt" {

 vpc_id = aws_vpc.main.id
 tags   = {
   Name = "2nd Route Table"
 }

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
}

resource "aws_subnet" "public_subnet" {

 vpc_id                  = aws_vpc.main.id
 cidr_block              = "10.0.0.0/24"
 map_public_ip_on_launch = true
 tags                    = {
   Name = "Public Subnet"
 }
}

resource "aws_route_table_association" "public_subnet_assc" {

 subnet_id      = aws_subnet.public_subnet.id
 route_table_id = aws_route_table.second_rt.id
}