
resource "aws_instance" "example" {
  ami                    = lookup(var.AMIS, var.AWS_REGION, "")
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main-public-1.id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = aws_key_pair.mykeypair.key_name
  user_data              = data.template_file.user_data.rendered


  provisioner "file" {
    source      = "templates/remote-script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo sed -i -e 's/\r$//' /tmp/script.sh", # Remove the spurious CR characters.
      "sudo /tmp/script.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.private_ip}\t${aws_instance.example.public_ip} >> ec2-ips.txt \n export aws_instance_public_ip=${aws_instance.example.public_ip} \n templates/local-script.sh"
  }
}

