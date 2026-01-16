resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-0ced6a024bb18ff2e"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t3.micro"
    key_name = "Devops"
    tags = {
        Name = "project"
    }
    
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-0618bde0a110ee5ac", "subnet-076d136168948f571"]
     listener {
      instance_port     = 80
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["ap-south-1a", "ap-south-1c"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
    
  }

