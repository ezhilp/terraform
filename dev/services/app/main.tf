provider "aws" {}

resource "aws_security_group" "sg_instance" {
	vpc_id = "${var.vpc}"
	name = "BMSTest"
	description = "BMSTest"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_elb" {
  name        = "BMSTest_elb"
  description = "BMSTest_elb"

  vpc_id = "${var.vpc}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
	ami = "${var.ami}"
	subnet_id = "${var.subnet}"
	instance_type = "t2.micro"
	key_name = "${var.key}"
	vpc_security_group_ids = ["${aws_security_group.sg_instance.id}"]
	tags = { Name = "Test" }
	user_data = "${file("userdata.sh")}"
  
  # ensure security group created
  depends_on = ["aws_security_group.sg_instance"]
}

resource "aws_elb" "web" {
  name = "bmstest-elb"

  # The same availability zone as our instance
  subnets = ["${var.subnet}"]

  security_groups = ["${aws_security_group.sg_elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # The instance is registered automatically

  instances                   = ["${aws_instance.web.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  # ensure instance created before this step
  depends_on = ["aws_instance.web"]

}

resource "aws_lb_cookie_stickiness_policy" "default" {
  name                     = "lbpolicy"
  load_balancer            = "${aws_elb.web.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

output "instance_id" {
	value = "${aws_instance.web.id}"
}

output "sg_instance" {
	value = "${aws_security_group.sg_instance.id}"
}

output "sg_elb" {
	value = "${aws_security_group.sg_elb.id}"
}

output "elb_id" {
	value = "${aws_elb.web.dns_name}"
}
