output "ec2_ip" {
  value = aws_instance.example.public_ip
}
output "ec2_dns" {
  value = aws_instance.example.public_dns
}

