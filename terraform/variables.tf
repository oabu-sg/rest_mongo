variable "private_key_file_path_var" {
  default = "/home/vagrant/.ssh/devops106_osama.pem"
}

variable "ubuntu_20_04_ami_id_var" {
  default = "ami-08ca3fed11864d6bb"
}

variable "webcalc_ami_var" {
  default = "ami-09eb8df719a033a09"
}

variable "public_key_name_var" {
  default = "devops106_osama"
}

variable "region_var" {
  default = "eu-west-1"
}

variable "health_check" {
   type = map(string)
   default = {
      "timeout"  = "10"
      "interval" = "15"
      "path"     = "/"
      "port"     = "8080"
      "unhealthy_threshold" = "2"
      "healthy_threshold" = "3"
    }
}

locals {
  vpc_id_var = aws_vpc.devops106_terraform_osama_vpc_tf.id
}