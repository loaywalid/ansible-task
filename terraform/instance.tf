resource "aws_instance" "private_instance1" {
  ami           = "ami-0d50e5e845c552faf"
  instance_type = "t3.xlarge"
  associate_public_ip_address = false
  subnet_id = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.sec_group.id]
  key_name = "taskkey"
 tags = {
    Name = "jumphost"
  }

}

resource "aws_instance" "private_instance2" {
  ami           = "ami-0d50e5e845c552faf"
  instance_type = "t3.xlarge"
  associate_public_ip_address = false
  subnet_id = aws_subnet.private2.id
  vpc_security_group_ids = [aws_security_group.sec_group.id]
  key_name = "taskkey"
}

resource "aws_instance" "jump_host" {
 ami           = "ami-0d50e5e845c552faf"
 instance_type = "t3.xlarge"
 associate_public_ip_address = true
 subnet_id = aws_subnet.public2.id
 vpc_security_group_ids = [aws_security_group.sec_group.id]
  key_name = "taskkey"

}
