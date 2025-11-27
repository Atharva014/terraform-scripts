# Create the service account for EBS CSI Controller
resource "kubernetes_service_account" "ebs_csi_controller" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.eks.ebs_csi_controller_role_arn
    }
    labels = {
      "app.kubernetes.io/name"       = "aws-ebs-csi-driver"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  # This ensures the service account is created after the cluster is ready
  depends_on = [module.eks]
}

# Service Account for AWS Load Balancer Controller
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.eks.alb_controller_role_arn
    }
    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  depends_on = [module.eks]
}