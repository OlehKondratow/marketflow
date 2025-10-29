# 16 – Ingestor Service & Helm Deployment

> az role assignment list \
  --assignee 0280abe8-9ccd-435b-ad84-6a46a8f7fbb9 \
  --scope $(az keyvault show -n marketflow-vault --query id -o tsv) \
  -o table

> az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee 0280abe8-9ccd-435b-ad84-6a46a8f7fbb9 \
  --scope $(az keyvault show -n marketflow-vault --query id -o tsv)
```json
{
  "condition": null,
  "conditionVersion": null,
  "createdBy": null,
  "createdOn": "2025-10-28T12:49:17.289800+00:00",
  "delegatedManagedIdentityResourceId": null,
  "description": null,
  "id": "/subscriptions/65fe7e97-9f6f-4f82-b940-4f374ca027cb/resourceGroups/marketflow-rg/providers/Microsoft.KeyVault/vaults/marketflow-vault/providers/Microsoft.Authorization/roleAssignments/65c80b8f-941c-4f5f-89c0-1de93c0998bd",
  "name": "65c80b8f-941c-4f5f-89c0-1de93c0998bd",
  "principalId": "64515080-80e9-45e8-9ecf-a9a11fe04c91",
  "principalType": "ServicePrincipal",
  "resourceGroup": "marketflow-rg",
  "roleDefinitionId": "/subscriptions/65fe7e97-9f6f-4f82-b940-4f374ca027cb/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6",
  "scope": "/subscriptions/65fe7e97-9f6f-4f82-b940-4f374ca027cb/resourceGroups/marketflow-rg/providers/Microsoft.KeyVault/vaults/marketflow-vault",
  "type": "Microsoft.Authorization/roleAssignments",
  "updatedBy": "9ef05d8f-5e3a-46a7-b56f-b494d734fee6",
  "updatedOn": "2025-10-28T12:49:17.651804+00:00"
}
```

az role assignment list   --assignee 0280abe8-9ccd-435b-ad84-6a46a8f7fbb9   --scope $(az keyvault show -n marketflow-vault --query id -o tsv)   -o json
```json
[
  {
    "condition": null,
    "conditionVersion": null,
    "createdBy": "9ef05d8f-5e3a-46a7-b56f-b494d734fee6",
    "createdOn": "2025-10-28T12:49:17.651804+00:00",
    "delegatedManagedIdentityResourceId": null,
    "description": null,
    "id": "/subscriptions/65fe7e97-9f6f-4f82-b940-4f374ca027cb/resourceGroups/marketflow-rg/providers/Microsoft.KeyVault/vaults/marketflow-vault/providers/Microsoft.Authorization/roleAssignments/65c80b8f-941c-4f5f-89c0-1de93c0998bd",
    "name": "65c80b8f-941c-4f5f-89c0-1de93c0998bd",
    "principalId": "64515080-80e9-45e8-9ecf-a9a11fe04c91",
    "principalName": "0280abe8-9ccd-435b-ad84-6a46a8f7fbb9",
    "principalType": "ServicePrincipal",
    "resourceGroup": "marketflow-rg",
    "roleDefinitionId": "/subscriptions/65fe7e97-9f6f-4f82-b940-4f374ca027cb/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6",
    "roleDefinitionName": "Key Vault Secrets User",
    "scope": "/subscriptions/65fe7e97-9f6f-4f82-b940-4f374ca027cb/resourceGroups/marketflow-rg/providers/Microsoft.KeyVault/vaults/marketflow-vault",
    "type": "Microsoft.Authorization/roleAssignments",
    "updatedBy": "9ef05d8f-5e3a-46a7-b56f-b494d734fee6",
    "updatedOn": "2025-10-28T12:49:17.651804+00:00"
  }
]
```

for t in ohlcv_raw trades_raw signals_raw; do
  az eventhubs eventhub create \
    --name $t \
    --namespace-name marketflow-kafka-ns \
    --resource-group marketflow-rg
done

Отлично — ниже объединённый, короткий и профессиональный файл **`16-ingestor.md`**, включающий описание **сервиса Ingestor** и **Helm-deployment**. Готов для репозитория `marketflow/charts/ingestor/`.

---
## Overview

**Ingestor** streams real-time crypto trades from **Binance WebSocket API** and publishes normalized messages to **Kafka**.
It’s part of the **MarketFlow data pipeline** and exposes Prometheus metrics for observability.

---

## 🧩 Core Functionality

1. Subscribes to Binance streams for pairs (`btcusdt`, `ethusdt`, `solusdt`).
2. Normalizes messages and sends them to Kafka topic `ohlcv_raw`.
3. Exports Prometheus metrics on port `:8000`.

**Stack:** Python 3.11 | `asyncio`, `uvloop`, `aiokafka`, `websockets`, `prometheus-client`, `loguru`

**Metrics:**

* `marketflow_ingestor_messages_sent_total`
* `marketflow_ingestor_latency_seconds`
* `marketflow_ingestor_ws_reconnects_total`

---

## ⚙️ Environment Variables

```bash
SYMBOLS=btcusdt,ethusdt,solusdt
KAFKA_BROKER=kafka:9092
KAFKA_TOPIC=ohlcv_raw
KAFKA_USERNAME=<user>
KAFKA_PASSWORD=<pass>
PROM_PORT=8000
```

---

## 🐳 Run (Docker)

```bash
docker build -t marketflow-ingestor .
docker run -it --rm \
  -p 9000:8000 \
  --env-file .env \
  marketflow-ingestor:v0.0.3
```

---

## ☸️ Helm Deployment

### Purpose

The Helm chart deploys the **MarketFlow Ingestor** to Kubernetes (AKS, GKE, or on-prem).
It automates container rollout, secret injection, and metrics discovery.

### Templates

| File                       | Description                                                     |
| -------------------------- | --------------------------------------------------------------- |
| `deployment.yaml`          | Defines pods, environment, and secret mounts via CSI/Key Vault. |
| `service.yaml`             | Exposes port 8000 (Prometheus metrics).                         |
| `serviceMonitor.yaml`      | Enables Prometheus Operator scraping (`/metrics`, every 30 s).  |
| `secretproviderclass.yaml` | Connects to secret storage for Kafka credentials.               |
| `_helpers.tpl`             | Common Helm labels and naming helpers.                          |

### Values Example (`values.yaml`)

```yaml
image:
  repository: marketflowregistry.azurecr.io/ingestor
  tag: v0.0.3

env:
  SYMBOLS: "btcusdt,ethusdt,solusdt"
  KAFKA_TOPIC: "ohlcv_raw"
  PROM_PORT: 8000
```

### Deploy Command

```bash
helm upgrade --install ingestor ./charts/ingestor \
  --namespace marketflow \
  --values values.yaml
```

---

## 🔗 Structure Overview

```
[Binance WS] → [Ingestor Pod] → [Kafka Topic: ohlcv_raw]
                        ↓
               [Service :8000]
                        ↓
              [ServiceMonitor → Prometheus → Grafana]
```
