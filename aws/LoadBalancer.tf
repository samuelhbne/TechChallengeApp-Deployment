resource "aws_elb" "elb1" {
    name                        = "${var.ENV}-elb1"
    subnets                     = [aws_subnet.pub_subnet1.id, aws_subnet.pub_subnet2.id]
    security_groups             = [aws_security_group.elb_sg1.id]

    health_check {
        target                  = "HTTP:80/"
        interval                = 300
        timeout                 = 60
        healthy_threshold       = 2
        unhealthy_threshold     = 10
    }

    listener {
        lb_port                 = 80
        lb_protocol             = "http"
        instance_port           = 80
        instance_protocol       = "http"
    }
}

output "elb_dns_name" {
    description                 = "The domain name of the load balancer"
    value                       = aws_elb.elb1.dns_name
}
