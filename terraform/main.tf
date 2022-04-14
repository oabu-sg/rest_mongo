provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "devops106_terraform_osama_vpc_tf" {
  cidr_block = "10.213.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "devops106_terraform_osama_vpc"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "devops106_terraform_osama_subnet_webserver_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.213.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]  

  tags = {
    Name = "devops106_terraform_osama_subnet_webserver"
  }
}

resource "aws_subnet" "devops106_terraform_osama_subnet_webserver_2_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.213.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]  

  tags = {
    Name = "devops106_terraform_osama_subnet_webserver"
  }
}

resource "aws_subnet" "devops106_terraform_osama_subnet_db_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.213.2.0/24"
  tags = {
    Name = "devops106_terraform_osama_subnet_db"
  }
}

resource "aws_internet_gateway" "devops106_terraform_osama_igw_tf" {
  vpc_id = local.vpc_id_var
  
  tags = {
    Name = "devops106_terraform_osama_igw"
  }
}

resource "aws_route_table" "devops106_terraform_osama_rt_public_tf" {
  vpc_id = local.vpc_id_var

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops106_terraform_osama_igw_tf.id
  }
  
  tags = {
    Name = "devops106_terraform_osama_rt_public"
  }
}

resource "aws_route_table_association" "devops106_terraform_osama_rt_assoc_public_webserver_tf" {
    subnet_id = aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id
    route_table_id = aws_route_table.devops106_terraform_osama_rt_public_tf.id
}

resource "aws_route_table_association" "devops106_terraform_osama_rt_assoc_public_webserver_2_tf" {
    subnet_id = aws_subnet.devops106_terraform_osama_subnet_webserver_2_tf.id
    route_table_id = aws_route_table.devops106_terraform_osama_rt_public_tf.id
}

resource "aws_route_table_association" "devops106_terraform_osama_rt_assoc_public_db_tf" {
    subnet_id = aws_subnet.devops106_terraform_osama_subnet_db_tf.id
    route_table_id = aws_route_table.devops106_terraform_osama_rt_public_tf.id
}

resource "aws_network_acl" "devops106_terraform_osama_nacl_public_tf" {
  vpc_id = local.vpc_id_var

  ingress {
    rule_no = 100
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  ingress {
    rule_no = 200
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress {
    rule_no = 250
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress {
    rule_no = 300
    from_port = 8080
    to_port = 8080
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  
  egress {
    rule_no = 100
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 200
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  subnet_ids = [aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id, aws_subnet.devops106_terraform_osama_subnet_webserver_2_tf.id]
  
  tags = {
    Name = "devops106_terraform_osama_nacl_public"
  }
}

resource "aws_network_acl" "devops106_terraform_osama_nacl_db_tf" {
  vpc_id = local.vpc_id_var

  ingress {
    rule_no = 100
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  ingress {
    rule_no = 200
    from_port = 27017
    to_port = 27017
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  ingress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  
  egress {
    rule_no = 100
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 200
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  subnet_ids = [aws_subnet.devops106_terraform_osama_subnet_db_tf.id]
  
  tags = {
    Name = "devops106_terraform_osama_nacl_db"
  }
}

resource "aws_security_group" "devops106_terraform_osama_sg_webserver_tf" {
    name = "devops106_terraform_osama_sg_webserver"
    vpc_id = local.vpc_id_var

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
      Name = "devops106_terraform_osama_sg_webserver"
    }
}

resource "aws_security_group" "devops106_terraform_osama_sg_db_tf" {
    name = "devops106_terraform_osama_sg_db"
    vpc_id = local.vpc_id_var

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
      from_port = 27017
      to_port = 27017
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
      Name = "devops106_terraform_osama_sg_db"
    }
}


resource "aws_security_group" "devops106_terraform_osama_sg_lb_tf" {
    name = "devops106_terraform_osama_sg_lb"
    vpc_id = local.vpc_id_var

    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    
    egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
      Name = "devops106_terraform_osama_sg_lb"
    }
}


data "template_file" "app_init" {
  template = file("../init-scripts/docker-install.sh")
}

data "template_file" "db_init" {
  template = file("../init-scripts/mongodb-install.sh")
}

data "template_file" "nginx_init" {
    template = file("../init-scripts/nginx-conf.sh")
    
    vars = {
      ip0 = aws_instance.devops106_terraform_osama_webserver_tf[0].private_ip
      ip1 = aws_instance.devops106_terraform_osama_webserver_tf[1].private_ip
      #ip2 = aws_instance.devops106_terraform_osama_webserver_tf[2].private_ip
    }
}

resource "aws_instance" "devops106_terraform_osama_webserver_tf" {
  ami = var.webcalc_ami_var
  instance_type = "t2.micro"
  key_name = "devops106_osama"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_osama_sg_webserver_tf.id]
  
  subnet_id = aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id
  associate_public_ip_address = true
  
  count = 2
  user_data = data.template_file.app_init.rendered
  
  tags = {
    Name = "devops106_terraform_osama_webserver_${count.index}"
  }
  
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }
  /*
  provisioner "file" {
    source = "../init-scripts/docker-install.sh"
    destination = "/home/ubuntu/docker-install.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "bash /home/ubuntu/docker-install.sh"
    ]
  }
  */
  
  /*
  provisioner "local-exec" {
      command = "echo mongodb://${aws_instance.devops106_terraform_osama_db_tf.public_ip}:27017 > ../database.config"
  }
  
  provisioner "file" {
    source = "../database.config"
    destination = "/home/ubuntu/database.config"
  }
  
  provisioner "remote-exec" {
    inline = [
      "docker run -d hello-world",
      "ls -la /home/ubuntu",
      "cat /home/ubuntu/database.config"
    ]
  }
  */
}

resource "aws_instance" "devops106_terraform_osama_nginx_tf" {
  ami = var.ubuntu_20_04_ami_id_var
  instance_type = "t2.micro"
  key_name = "devops106_osama"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_osama_sg_webserver_tf.id]
  
  subnet_id = aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id
  associate_public_ip_address = true
  
  user_data = data.template_file.nginx_init.rendered
  
  tags = {
    Name = "devops106_terraform_osama_nginx"
  }
}

resource "aws_instance" "devops106_terraform_osama_webserver_2_tf" {
  ami = var.ubuntu_20_04_ami_id_var
  instance_type = "t2.micro"
  key_name = "devops106_osama"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_osama_sg_webserver_tf.id]
  
  subnet_id = aws_subnet.devops106_terraform_osama_subnet_webserver_2_tf.id
  associate_public_ip_address = true
  
  count = 2
  user_data = data.template_file.app_init.rendered
  
  tags = {
    Name = "devops106_terraform_osama_webserver_2_${count.index}"
  }
}

resource "aws_instance" "devops106_terraform_osama_db_tf" {
  ami = var.ubuntu_20_04_ami_id_var
  instance_type = "t2.micro"
  key_name = var.public_key_name_var
  vpc_security_group_ids = [aws_security_group.devops106_terraform_osama_sg_db_tf.id]
  
  subnet_id = aws_subnet.devops106_terraform_osama_subnet_db_tf.id
  associate_public_ip_address = true
  tags = {
    Name = "devops106_terraform_osama_db"
  }
  
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }
  
  user_data = data.template_file.db_init.rendered
  
  /*
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -",
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list",
      "sudo apt update",
      "sudo apt install -y mongodb-org",
      "sudo systemctl start mongod.service",
      #"sudo systemctl status mongod",
      "sudo systemctl enable mongod",
      "mongo --eval 'db.runCommand({ connectionStatus: 1 })'",
      ## sudo sed -i "s/bindIp: 127.0.0.1/bindIp:0.0.0.0/" /etc/mongod.conf
      "sudo sed -i \"s/bindIp: 127.0.0.1/bindIp:0.0.0.0/\" /etc/mongod.conf",
      "sudo systemctl restart mongod.service",
    ]
    
  }
  */
}

resource "aws_route53_zone" "devops106_terraform_osama_dns_zone_tf" {
    name = "osama.devops106"
    
    vpc {
      vpc_id = local.vpc_id_var
    }
}

resource "aws_route53_record" "devops106_terraform_osama_dns_db_tf" {
  zone_id = aws_route53_zone.devops106_terraform_osama_dns_zone_tf.zone_id
  name = "db"
  type = "A"
  ttl = "30"
  records = [aws_instance.devops106_terraform_osama_db_tf.public_ip]
}

resource "aws_route53_record" "devops106_terraform_osama_dns_webservers_tf" {
  zone_id = aws_route53_zone.devops106_terraform_osama_dns_zone_tf.zone_id
  type = "A"
  ttl = "30"
  name = "app"
  records = aws_instance.devops106_terraform_osama_webserver_tf.*.private_ip
}
/*
resource "aws_lb" "devops106_terraform_osama_lb_tf" {
  name = "devops106terraformosama-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id, aws_subnet.devops106_terraform_osama_subnet_webserver_2_tf.id]
  security_groups = [aws_security_group.devops106_terraform_osama_sg_lb_tf.id]
  
  tags = {
    Name = "devops106_terraform_osama_lb"
  }
}

resource "aws_alb_target_group" "devops106_terraform_osama_tg_tf"{
  name = "devops106terraformosama-tg"
  port = 8080
  target_type = "instance"
  protocol = "HTTP"
  vpc_id = local.vpc_id_var
}
*/
/*
resource "aws_alb_target_group_attachment" "devops106_terraform_osama_tg_attach_0_server_tf" {
  target_group_arn = aws_alb_target_group.devops106_terraform_osama_tg_tf.arn
  target_id = aws_instance.devops106_terraform_osama_webserver_tf[0].id
}

resource "aws_alb_target_group_attachment" "devops106_terraform_osama_tg_attach_1_server_tf" {
  target_group_arn = aws_alb_target_group.devops106_terraform_osama_tg_tf.arn
  target_id = aws_instance.devops106_terraform_osama_webserver_tf[1].id
}
*/
/*
resource "aws_alb_target_group_attachment" "devops106_terraform_osama_tg_attach_tf" {
  target_group_arn = aws_alb_target_group.devops106_terraform_osama_tg_tf.arn
  count = length(aws_instance.devops106_terraform_osama_webserver_tf)
  target_id = aws_instance.devops106_terraform_osama_webserver_tf[count.index].id
}

resource "aws_alb_target_group_attachment" "devops106_terraform_osama_tg_2_attach_tf" {
  target_group_arn = aws_alb_target_group.devops106_terraform_osama_tg_tf.arn
  count = length(aws_instance.devops106_terraform_osama_webserver_2_tf)
  target_id = aws_instance.devops106_terraform_osama_webserver_2_tf[count.index].id
}

resource "aws_alb_listener" "devops106_terraform_osama_lb_listener_tf" {
    load_balancer_arn = aws_lb.devops106_terraform_osama_lb_tf.arn
    port = 80
    protocol = "HTTP"
    
    default_action {
      type = "forward"
      target_group_arn = aws_alb_target_group.devops106_terraform_osama_tg_tf.arn
    }
}
*/