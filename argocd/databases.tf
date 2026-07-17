# ==========================================
# DATA LAYER NAMESPACE
# ==========================================
resource "kubernetes_namespace_v1" "data_layer" {
  metadata {
    name = "data-layer"
  }
}

# ==========================================
# REAL REDIS (Raw K8s - No Helm, No Headache)
# ==========================================
resource "kubernetes_deployment_v1" "redis" {
  metadata {
    name      = "redis-cache"
    namespace = kubernetes_namespace_v1.data_layer.metadata[0].name

    labels = {
      app = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {

        container {
          name  = "redis"
          image = "redis:7-alpine"

          port {
            container_port = 6379
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service_v1" "redis_service" {

  metadata {
    name      = "redis-cache"
    namespace = kubernetes_namespace_v1.data_layer.metadata[0].name
  }

  spec {

    selector = {
      app = "redis"
    }

    port {
      port        = 6379
      target_port = 6379
    }
  }
}

# ==========================================
# K8S SECRET (Environment Variables)
# ==========================================
resource "kubernetes_secret_v1" "app_db_secrets" {
  metadata {
    name      = "app-db-credentials"
    namespace = "default"
  }
  data = {
    REDIS_HOST = "redis-cache.data-layer.svc.cluster.local"
  }
}