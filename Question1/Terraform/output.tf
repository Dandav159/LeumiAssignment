output "cluster_name" {

  description = "EKS cluster name"
  value       = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {

  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.eks.endpoint
}

output "jenkins_service_account_token" {

  description = "Jenkins service account token"
  value       = kubernetes_secret.jenkins_service_account_token.data["token"]
  sensitive   = true
}