# EBS CSI Driver Add-on
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.37.0-eksbuild.1"  # You can specify version or use latest
  service_account_role_arn = module.eks.ebs_csi_controller_role_arn
  
  # Resolve conflicts by overwriting
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name        = "aws-ebs-csi-driver"
    Environment = "production"
  }

  depends_on = [
    module.eks,
    kubernetes_service_account.ebs_csi_controller
  ]
}