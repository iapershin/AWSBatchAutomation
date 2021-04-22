variable "environment" {
  description = "Environment"
  type        = string
}

variable "image_tag" {
  description = "Image tag which will be used by job"
  type        = string
}

variable "execution_role" {
  description = "Execution role"
  type        = string
}

variable "cloudwatch_role" {
  description = "CloudWatch role"
  type        = string
}

variable "container_registry" {
  description = "Container registry URL"
  type        = string
}

variable "batch_queue_prefix" {
  description = "Batch queue prefix ARN"
  type        = string
}

variable "container"{
  type = object({
    vcpus = number,
    memory = number
  })
}
