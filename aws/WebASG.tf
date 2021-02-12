resource "aws_autoscaling_group" "web_asg1" {
    name                            = "${var.ENV}-web_asg"
    vpc_zone_identifier             = [aws_subnet.pub_subnet1.id, aws_subnet.pub_subnet2.id]
    launch_template {
        id                          = aws_launch_template.web_launch_template1.id
        version                     = aws_launch_template.web_launch_template1.latest_version
    }
    desired_capacity                = 1
    min_size                        = 1
    max_size                        = 2
    load_balancers                  = [aws_elb.elb1.name]
    health_check_type               = "ELB"
    health_check_grace_period       = 300
    enabled_metrics                 = [
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupMaxSize",
        "GroupMinSize",
        "GroupPendingInstances",
        "GroupStandbyInstances",
        "GroupTerminatingInstances",
        "GroupTotalInstances",
    ]
}

data "template_file" "appinit" {
    template = file("app.tpl")
    vars = {
        DBNAME                      = var.DBNAME
        PGUSER                      = var.PGUSER
        PGPASS                      = var.PGPASS
        PGHOST                      = aws_rds_cluster.pgcluster1.endpoint
    }
}

resource "aws_launch_template" "web_launch_template1" {
    name                            = "${var.ENV}-web_launch_template1"
    instance_type                   = var.instance_type_web
    image_id                        = var.ami_web
    key_name                        = aws_key_pair.key1.key_name
    user_data                       = base64encode(data.template_file.appinit.rendered)
    network_interfaces {
        associate_public_ip_address = true
        delete_on_termination       = true
        security_groups             = [aws_security_group.web_sg1.id]
    }
    monitoring {
        enabled                     = true
    }
}
