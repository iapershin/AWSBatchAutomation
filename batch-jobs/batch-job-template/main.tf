resource "aws_batch_job_definition" "batch_job" {
  name = "batch_job-${var.environment}"
  type = "container"
  retry_strategy {
    attempts = 2
  }
  timeout {
    attempt_duration_seconds = 240
  }
  container_properties = <<CONTAINER_PROPERTIES
{
  "command": [<command>],
  "environment": [],
  "executionRoleArn": "${var.execution_role}",
  "image": "${var.container_registry}/batch-job:${var.image_tag}",
  "jobRoleArn": "${var.execution_role}",
  "linuxParameters": {
    "devices": [],
    "tmpfs": []
  },
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {},
    "secretOptions": []
  },
  "mountPoints": [],
  "resourceRequirements": [
    {
      "type": "VCPU",
      "value": "${var.container.vcpus}"
    },
    {
      "type": "MEMORY",
      "value": "${var.container.memory}"
    }
  ],
  "secrets": [],
  "ulimits": [],
  "volumes": []
}
CONTAINER_PROPERTIES
  tags = {
    Environment      = upper(var.environment)
    Name             = "job definition"
  }
}

resource "aws_cloudwatch_event_rule" "batch_job-event-rule" {
  name        = "batch_job-event-rule-${var.environment}"
  description = "${upper(var.environment)} - run batch job"

  event_pattern = <<EOF
{
  <event_pattern>
}
EOF
  tags = {
    Environment      = upper(var.environment)
    Name             = "batch_job-event-rule"
  }
}

resource "aws_cloudwatch_event_target" "batch_job-rule-target" {
  arn = "${var.batch_queue_prefix}/batch_job-queue"
  rule = aws_cloudwatch_event_rule.batch_job-event-rule.name
  role_arn = var.cloudwatch_role

  batch_target {
    job_definition = aws_batch_job_definition.batch_job.arn
    job_name       = "batch_job-job"
  }

  input_transformer {
    input_paths = {
      # e.g. S3BucketValue = "$.detail.requestParameters.bucketName",
    }
    input_template = <<EOF
<input_template>
EOF
  }

  retry_policy {
    maximum_event_age_in_seconds = 600
    maximum_retry_attempts = 60
  }
}

//test2
