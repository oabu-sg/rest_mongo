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


data "template_file" "db_init" {
  template = file("../init-scripts/mongodb-install.sh")
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

resource "aws_alb_listener" "devops106_terraform_osama_lb_listener_tf" {
    load_balancer_arn = aws_lb.devops106_terraform_osama_lb_tf.arn
    port = 80
    protocol = "HTTP"
    
    default_action {
      type = "forward"
      target_group_arn = aws_alb_target_group.devops106_terraform_osama_tg_tf.arn
    }
}

resource "aws_autoscaling_group" "devops106_terraform_osama_asg_tf" {
    name = "devops106_terraform_osama_asg"
    health_check_type = "ELB"
    health_check_grace_period = 120
    min_size = 1
    desired_capacity = 2
    max_size = 5
    vpc_zone_identifier = [
      aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id, 
      aws_subnet.devops106_terraform_osama_subnet_webserver_2_tf.id
    ]
    target_group_arns = [aws_alb_target_group.devops106_terraform_osama_tg_tf.arn]

    launch_template {
      id = aws_launch_template.devops106_terraform_osama_lt_tf.id
    }
    
    metrics_granularity = "1Minute"
    
    enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupTotalInstances"
    ]
}

resource "aws_autoscaling_policy" "devops106_terraform_osama_asg_policy_tf" {
  name = "devops106_terraform_osama_asg_policy"
  autoscaling_group_name = aws_autoscaling_group.devops106_terraform_osama_asg_tf.name
  
  policy_type = "TargetTrackingScaling"
  
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  
}

data "template_file" "app_init" {
  template = file("../init-scripts/app-launch.sh")
}

resource "aws_launch_template" "devops106_terraform_osama_lt_tf" {
  name = "devops106_terraform_osama_lt"
  image_id = "ami-09eb8df719a033a09"
  instance_type = "t2.micro"
  key_name = "devops106_osama"
  
  network_interfaces {
    associate_public_ip_address = true
    subnet_id = aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id
    security_groups = [aws_security_group.devops106_terraform_osama_sg_webserver_tf.id]
    delete_on_termination = true
  }
  
  user_data = base64encode(data.template_file.app_init.rendered)
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "devops106_terraform_osama_webserver"
    }
  }
}