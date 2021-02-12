resource "aws_cloudwatch_dashboard" "dashboard1" {
  dashboard_name = "${var.ENV}-dashboard1"

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", "${aws_autoscaling_group.web_asg1.name}" ],
                    [ ".", "GroupDesiredCapacity", ".", "." ]
                ],
                "region": "${var.AWS_REGION}",
                "title": "AudoScaling"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/ELB", "HealthyHostCount", { "stat": "Average" } ],
                    [ ".", "RequestCount" ],
                    [ ".", "UnHealthyHostCount" ],
                    [ ".", "HTTPCode_ELB_5XX" ],
                    [ ".", "HTTPCode_Backend_2XX" ],
                    [ ".", "BackendConnectionErrors" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.AWS_REGION}",
                "title": "ELB",
                "period": 300,
                "stat": "Sum"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${aws_autoscaling_group.web_asg1.name}" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.AWS_REGION}",
                "period": 300,
                "title": "EC2-CPU",
                "stat": "Average"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/EC2", "DiskReadOps", "AutoScalingGroupName", "${aws_autoscaling_group.web_asg1.name}" ],
                    [ ".", "DiskWriteOps", ".", "." ]
                ],
                "region": "${var.AWS_REGION}",
                "title": "EC2-IO"
            }
        }
    ]
}
EOF
}