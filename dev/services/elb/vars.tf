variable "vpc" {
	description = "VPC to be used"
	default = "vpc-dc5f6bb8"
}

variable "subnet" {
	description = "Subnet to be used"
	default = "subnet-f2fb72bb"
}

variable "ami" {
	description = "AMI for instance"
	default = "ami-e13739f6"
}

variable "key" {
	description = "Key pair to be used"
	default = "ezhil-brillio"
}
