resource "aws_s3_bucket" "dist_bucket" {
  bucket = "${var.namespace}-elb-dist"
  acl    = "private"
}
resource "aws_s3_object" "dist_item" {
  key    = "${var.environment}/dist-${uuid()}"
  bucket = aws_s3_bucket.dist_bucket.id
  source = "../${var.dist_zip}"
}

resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = "nodeapp"
}

# Create elastic beanstalk Environment

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "${var.namespace}-${var.environment}-${uuid()}"
  application = aws_elastic_beanstalk_application.elasticapp.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.dist_bucket.id
  key         = aws_s3_object.dist_item.id
}

resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  name                = "nodeapp"
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = var.solution_stack_name
  version_label       = aws_elastic_beanstalk_application_version.default.name
  tier                = var.tier

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "True"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnets)
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.medium"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
}
