output "cluster_name" {

  description = "EKS cluster name"
  value       = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {

  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.eks.endpoint
}
