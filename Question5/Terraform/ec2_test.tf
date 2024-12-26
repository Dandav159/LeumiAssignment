### EC2 test instance ###

resource "aws_instance" "ec2_test" {

  ami                    = "ami-0c5f2ae8ffbf87673"
  instance_type          = "t2.micro"
  private_ip             = "10.0.0.12"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.leumi_proxy_sg.id]
  tags                   = {
    Name = "ec2_test"
  }
}

resource "aws_security_group" "leumi_proxy_sg" {

  name        = "leumi_proxy_sg"
  description = "Allows http traffic from Leumi Proxy"
  vpc_id      = aws_vpc.main.id
  tags        = {
    Name = "leumi_proxy_sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["91.231.246.50/32"]
  }
}

resource "aws_eip" "elastic_ip_ec2_test" {

  domain                    = "vpc"
  instance                  = aws_instance.ec2_test.id
  associate_with_private_ip = "10.0.0.12"

  depends_on                = [aws_internet_gateway.gw]
}