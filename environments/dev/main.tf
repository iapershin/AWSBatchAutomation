variable "environment" {}
variable "image_tag" {}
variable "execution_role" {}
variable "cloudwatch_role" {}
variable "container_registry" {}
variable "batch_queue_prefix" {}

module "batch-job-template-dev" {
  source = "../../batch-jobs/batch-job-template"
  environment = var.environment
  image_tag = var.image_tag
  execution_role = var.execution_role
  cloudwatch_role = var.cloudwatch_role
  container_registry = var.container_registry
  batch_queue_prefix = var.batch_queue_prefix
  container = {
    vcpus  = 1,
    memory = 768}
}

