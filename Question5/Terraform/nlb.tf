### NLB ###

resource "aws_lb" "nlb" {

  name               = "nlb"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.leumi_proxy_sg.id]

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet.id
  }
}

resource "aws_lb_listener" "ec2_test_listener" {

  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_test_tg.arn
  }
}

resource "aws_lb_target_group" "ec2_test_tg" {

  name        = "ec2-test-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "ec2_test_tg_attch" {

  target_group_arn = aws_lb_target_group.ec2_test_tg.arn
  target_id        = aws_instance.ec2_test.id
}