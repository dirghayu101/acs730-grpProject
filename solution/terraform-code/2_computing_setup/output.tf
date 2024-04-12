output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "initial_webserver_private_ip" {
  value = aws_instance.default_instance.private_ip
}

output "bastion_id" {
    value = aws_instance.bastion_host.id
}

output "default_webserver_id" {
    value = aws_instance.default_instance.id
}

output "ami_ids" {
    value = aws_instance.default_instance.ami
}

output "bastion_sg_id" {
    value = aws_security_group.bastion_sg.id
}

output "webserver_sg_id" {
    value = aws_security_group.web_server_sg.id
}