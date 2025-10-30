resource "kubernetes_namespace" "app" {
  metadata { name = "httpbin" }
}

resource "kubernetes_deployment" "httpbin" {
  metadata {
    name      = "httpbin"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "httpbin" } }
    template {
      metadata { labels = { app = "httpbin" } }
      spec {
        container {
          name  = "httpbin"
          image = "kennethreitz/httpbin"
          port { container_port = 80 }
        }
      }
    }
  }
}
