# Create EC2
resource "aws_instance" "wordpress1" {
  ami                    = "ami-0cff7528ff583bf9a"
  instance_type          = var.i_type
  subnet_id              = aws_subnet.private_subnet-1.id
  vpc_security_group_ids = ["${aws_security_group.ec2_allow_rule.id}"]
  user_data              = "${file("data2.sh")}"
  tags = {
    Name = "Wordpress1.web"
  }

  # this will stop creating EC2 before RDS is provisioned
 # depends_on = [aws_db_instance.wordpressdb]
}
# Create EC2
resource "aws_instance" "wordpress2" {
  ami                    = "ami-0cff7528ff583bf9a"
  instance_type          = var.i_type
  subnet_id              = aws_subnet.private_subnet-2.id
  vpc_security_group_ids = ["${aws_security_group.ec2_allow_rule.id}"]
  user_data              = "${file("data2.sh")}"
  tags = {
    Name = "Wordpress2.web"
  }

  # this will stop creating EC2 before RDS is provisioned
 # depends_on = [aws_db_instance.wordpressdb]
}
