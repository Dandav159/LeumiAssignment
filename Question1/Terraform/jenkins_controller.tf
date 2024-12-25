### Jenkins Controller ###

resource "aws_instance" "jenkins_controller" {

  ami                         = var.jenkins_controller_ami
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.public_subnets[0].id
  associate_public_ip_address = true
  key_name                    = "JenkinsKey"
  vpc_security_group_ids      = [
    aws_security_group.jenkins_sg.id
  ]
  tags                        = {
    Name = "JenkinsController"
  }

  depends_on = [
    aws_subnet.public_subnets
  ]
}

resource "aws_security_group" "jenkins_sg" {

  name        = "jenkins_sg"
  description = "Allow SSH, HTTP and 8080 inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  tags        = {
    Name = "jenkins_sg"
  }

  dynamic "ingress" {
    for_each = var.ingress_rules_jenkins_sg

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}