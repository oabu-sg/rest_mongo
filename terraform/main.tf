provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "devops106_terraform_osama_vpc_tf" {
  cidr_block = "10.213.0.0/16"
  
  tags = {
    Name = "devops106_terraform_osama_vpc"
  }
}

resource "aws_subnet" "devops106_terraform_osama_subnet_webserver_tf" {
  vpc_id = aws_vpc.devops106_terraform_osama_vpc_tf.id
  cidr_block = "10.213.1.0/24"
  
  tags = {
    Name = "devops106_terraform_osama_subnet_webserver"
  }
}

resource "aws_subnet" "devops106_terraform_osama_subnet_db_tf" {
  vpc_id = aws_vpc.devops106_terraform_osama_vpc_tf.id
  cidr_block = "10.213.2.0/24"
  
  tags = {
    Name = "devops106_terraform_osama_subnet_db"
  }
}

resource "aws_internet_gateway" "devops106_terraform_osama_igw_tf" {
  vpc_id = aws_vpc.devops106_terraform_osama_vpc_tf.id
  
  tags = {
    Name = "devops106_terraform_osama_igw"
  }
}

resource "aws_route_table" "devops106_terraform_osama_rt_public_tf" {
  vpc_id = aws_vpc.devops106_terraform_osama_vpc_tf.id

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

resource "aws_route_table_association" "devops106_terraform_osama_rt_assoc_public_db_tf" {
    subnet_id = aws_subnet.devops106_terraform_osama_subnet_db_tf.id
    route_table_id = aws_route_table.devops106_terraform_osama_rt_public_tf.id
}

resource "aws_network_acl" "devops106_terraform_osama_nacl_public_tf" {
  vpc_id = aws_vpc.devops106_terraform_osama_vpc_tf.id

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
  
  subnet_ids = [aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id]
  
  tags = {
    Name = "devops106_terraform_osama_nacl_public"
  }
}

resource "aws_network_acl" "devops106_terraform_osama_nacl_db_tf" {
  vpc_id = aws_vpc.devops106_terraform_osama_vpc_tf.id

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
    vpc_id = aws_vpc.devops106_terraform_osama_vpc_tf.id

    ingress {
        from_port = 22
        to_port = 22
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
    vpc_id = aws_vpc.devops106_terraform_osama_vpc_tf.id

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

resource "aws_instance" "devops106_terraform_osama_webserver_tf" {
  ami = "ami-08ca3fed11864d6bb"
  instance_type = "t2.micro"
  key_name = "devops106_osama"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_osama_sg_webserver_tf.id]
  
  subnet_id = aws_subnet.devops106_terraform_osama_subnet_webserver_tf.id
  associate_public_ip_address = true
  tags = {
    Name = "devops106_terraform_osama_webserver"
  }
  
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/vagrant/.ssh/devops106_osama.pem")
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get remove -y docker docker-engine docker.io containerd runc",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo usermod -a -G docker ubuntu",
    ]
  }
  
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
}

resource "aws_instance" "devops106_terraform_osama_db_tf" {
  ami = "ami-08ca3fed11864d6bb"
  instance_type = "t2.micro"
  key_name = "devops106_osama"
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
    private_key = file("/home/vagrant/.ssh/devops106_osama.pem")
  }
  
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -",
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list",
      "sudo apt update",
      "sudo apt install -y mongodb-org",
      "sudo systemctl start mongod.service",
      "sudo systemctl status mongod",
      "sudo systemctl enable mongod",
      #"mongo --eval 'db.runCommand({ connectionStatus: 1 })'",
      ## sudo sed -i "s/bindIp: 127.0.0.1/bindIp:0.0.0.0/" /etc/mongod.conf
      "sudo sed -i \"s/bindIp: 127.0.0.1/bindIp:0.0.0.0/\" /etc/mongod.conf",
      "sudo systemctl restart mongod.service",
    ]
    
  }
}
