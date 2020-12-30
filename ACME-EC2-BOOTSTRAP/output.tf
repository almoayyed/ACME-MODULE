output "inst_id" {
  value = "${aws_instance.ec2_instance.id}"
}

output "inst_public" {
  value = "${aws_instance.ec2_instance.public_ip}"
}

output "inst_publicdns" {
  value = "${aws_instance.ec2_instance.public_dns}"
}