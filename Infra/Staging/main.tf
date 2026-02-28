############################################
# DATA SOURCES
############################################

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

############################################
# ECS CLUSTER
############################################

resource "aws_ecs_cluster" "dev_cluster" {
  name = "pgagi-cluster-Staging"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "pgagi"
  }
}

############################################
# CLOUDWATCH LOG GROUP
############################################

resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/ecs/pgagi-backend-Staging"
  retention_in_days = 7

  tags = {
    Environment = "dev"
    Project     = "pgagi"
  }
}

############################################
# ALB SECURITY GROUP
############################################

resource "aws_security_group" "alb_sg" {
  name        = "pgagi-alb-sg-Staging"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "dev"
    Project     = "pgagi"
  }
}

############################################
# BACKEND SECURITY GROUP
############################################

resource "aws_security_group" "backend_sg" {
  name        = "pgagi-backend-sg-Staging"
  description = "Security group for backend service"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "dev"
    Project     = "pgagi"
  }
}

############################################
# ECS TASK DEFINITION
############################################

resource "aws_ecs_task_definition" "backend_task" {
  family                   = "pgagi-backend-Staging"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn = "arn:aws:iam::550869128317:role/pgagi-ecs-task-execution-role-dev"
  container_definitions = jsonencode([{
    name      = "pgagi-backend"
    image     = "550869128317.dkr.ecr.ap-south-1.amazonaws.com/pgagi-backend:latest"
    essential = true

    portMappings = [{
      containerPort = 5000
      hostPort      = 5000
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.backend_logs.name
        awslogs-region        = "ap-south-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

############################################
# ALB
############################################

resource "aws_lb" "backend_alb" {
  name               = "pgagi-backend-alb-Staging"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "backend_tg" {
  name        = "pgagi-backend-tg-Staging"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    path = "/api/health"
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

############################################
# ECS SERVICE
############################################

resource "aws_ecs_service" "backend_service" {
  name            = "pgagi-backend-service-Staging"
  cluster         = aws_ecs_cluster.dev_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.backend_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_tg.arn
    container_name   = "pgagi-backend"
    container_port   = 5000
  }

  depends_on = [
    aws_lb_listener.backend_listener
  ]
}

############################################
# AUTO SCALING
############################################

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.dev_cluster.name}/${aws_ecs_service.backend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "pgagi-cpu-scaling-policy-dev"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}