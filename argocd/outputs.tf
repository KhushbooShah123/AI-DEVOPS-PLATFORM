output "argocd_password" {
  value     = data.kubernetes_secret_v1.argocd_admin_secret.data["password"]
  sensitive = true
}
output "argocd_port_forward" {
  description = "Command to access ArgoCD UI locally"
  value       = "kubectl port-forward svc/${helm_release.argocd.name}-server -n ${helm_release.argocd.namespace} 8080:443"
}

output "argocd_password_command" {
  description = "Command to get ArgoCD admin password"
  value       = "terraform output -raw argocd_password"
}

# GRAFANA OUTPUTS (Monitoring)
# ==========================================
output "grafana_password" {
  description = "Grafana Admin Password"
  value       = "admin123" # Jo humne monitoring.tf me set kiya tha
}

output "grafana_port_forward" {
  description = "Command to access Grafana UI locally"
  value       = "kubectl port-forward svc/${helm_release.prometheus.name}-grafana -n ${kubernetes_namespace_v1.monitoring.metadata[0].name} 8081:80"
}


# # ALB ka status lene ke liye (DATA BLOCK ZAROORI HAI)
# data "kubernetes_ingress_v1" "alb_status" {
#   depends_on = [kubernetes_ingress_v1.app_ingress]
#   metadata {
#     name      = "app-ingress"
#     namespace = "default"
#   }
# }

# # Ye line ALB URL ko terminal pe dikhayegi
# output "alb_public_url" {
#   description = "🔥 OPEN THIS URL IN BROWSER"
#   value       = "http://${data.kubernetes_ingress_v1.alb_status.status[0].load_balancer[0].ingress[0].hostname}"
# }