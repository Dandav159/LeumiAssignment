### Namespaces ###

resource "kubernetes_namespace" "jenkins" {

  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_namespace" "app" {

  metadata {
    name = "app"
  }
}

### Jenkins service account ###

resource "kubernetes_service_account" "jenkins" {

  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
}

### Jenkins cluster role ###

resource "kubernetes_cluster_role" "jenkins_role" {

  metadata {
    name = "jenkins-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "watch", "list", "create", "delete"]
  }
}

### Role binding ###

resource "kubernetes_cluster_role_binding" "jenkins_role_binding" {

  metadata {
    name = "jenkins-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.jenkins_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins.metadata[0].name
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
}

### Secret token ###

resource "kubernetes_secret" "jenkins_service_account_token" {

  metadata {
    name      = "jenkins-sa-token"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.jenkins.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}