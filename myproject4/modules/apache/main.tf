provider "aws" {
  region = var.aws_region
}

variable "ec2_instance_id" {}

resource "remote-exec" "install_apache" {
  inline = [
    "sudo yum update -y",
    "sudo yum install -y httpd",
    "sudo systemctl start httpd",
    "sudo systemctl enable httpd"
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/your-key.pem")  # Replace with your private key path
    host        = aws_instance.ec2_instance.public_ip
  }
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}