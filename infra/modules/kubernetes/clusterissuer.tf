resource "kubernetes_manifest" "clusterissuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = { name = "letsencrypt-prod" }
    spec = {
      acme = {
        email  = "oleh.kondracki@gmail.com"
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = { name = "letsencrypt-prod-account-key" }
        solvers = [{
          dns01 = {
            cloudflare = {
              email = "admin@marketflow.ai"
              apiTokenSecretRef = {
                name = "cloudflare-api-token-secret"
                key  = "api-token"
              }
            }
          }
        }]
      }
    }
  }
}
