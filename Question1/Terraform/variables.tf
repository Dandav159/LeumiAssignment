### VPC ###

variable "aws_region" {

  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "public_subnet_cidrs" {

 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "azs" {

 type        = list(string)
 description = "Availability Zones"
 default     = ["eu-central-1a", "eu-central-1b"]

}

### Jenkins Controller ###

variable "jenkins_controller_ami" {

  description = "AMI for jenkins controller"
  type        = string
  default     = "ami-06eaa0dd9cd67272e"
}

variable "ingress_rules_jenkins_sg" {

  type    = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

### EKS ###

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "assignment-cluster"
}

variable "desired_capacity" {
  description = "Desired number of nodes in the managed node group"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of nodes in the managed node group"
  type        = number
  default     = 3
}

variable "min_capacity" {
  description = "Minimum number of nodes in the managed node group"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type for the EKS nodes"
  type        = string
  default     = "t2.medium"
}
