provider "aws" {}

resource "aws_security_group" "security_allow_all" {
	vpc_id = "${var.vpc}"
	name = "BMSTest"
	description = "BMSTest"
  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" sample {
	ami = "${var.ami}"
	subnet_id = "${var.subnet}"
	instance_type = "t2.micro"
	key_name = "${var.key}"
	security_groups = ["${aws_security_group.security_allow_all.id}"]
	tags = { Name = "Test" }
	user_data = "${file("userdata.sh")}"
}

output "instance_id" {
	value = "${aws_instance.sample.id}"
}

output "security_group_id" {
	value = "${aws_security_group.security_allow_all.id}"
}
