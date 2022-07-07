# Creating an Application Load Balancer

resource "aws_lb" "web-alb" {
  name               = "WebApp-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.public_subnet-1.id, aws_subnet.public_subnet-2.id]
}
# Creating a Target Group for my Application Load Balancer

resource "aws_lb_target_group" "alb" {
  name     = "web-app-tg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.web_app_vpc.id

  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = "600"
  }
}

# alb  target group attachment

resource "aws_lb_target_group_attachment" "wordpress1" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        =  aws_instance.wordpress1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "wordpress2" {
  target_group_arn = aws_lb_target_group.alb.arn
  target_id        =  aws_instance.wordpress2.id
  port = 80
}

# Forward Traffic to The Target Group

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}
