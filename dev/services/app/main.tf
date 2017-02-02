provider "aws" {}

resource "aws_instance" sample {
	ami = "{var.ami}"
	subnet_id = "{var.subnet}"
	instance_type = "t2.micro"
	key_name = "{var.key}"
}

output "sample" {
	value = "${aws_instance.sample.id}"
}
