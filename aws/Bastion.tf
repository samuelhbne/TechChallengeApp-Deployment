resource "aws_instance" "bastion1" {
  key_name                      = aws_key_pair.key1.key_name
  ami                           = var.ami_bastion
  instance_type                 = var.instance_type_bastion
  subnet_id                     = aws_subnet.pub_subnet2.id
  associate_public_ip_address   = true
  vpc_security_group_ids        = [aws_security_group.bastion_sg1.id]
  tags = {
    Name = "${var.ENV}-bastion1"
  }
}

output "bastion_host_ip_address" {
  description                 = "Bastion host IP address"
  value                       = aws_instance.bastion1.public_ip
}