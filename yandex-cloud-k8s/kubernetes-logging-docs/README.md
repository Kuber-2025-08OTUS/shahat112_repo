# Домашнее задание: Kubernetes Logging с Loki

## Выполненные задачи

### ✅ 1. Развернут managed Kubernetes cluster в Yandex Cloud
- **Версия Kubernetes**: 1.30
- **Релизный канал**: STABLE
- **Мастер-нода**: с публичным IP
- **External endpoint**: https://51.250.90.137

### ✅ 2. Создано 2 пула нод
| Тип нод | Количество | Labels | Назначение |
|---------|------------|---------|------------|
| Infra   | 1          | `node-role=infra` | Для инфраструктурных сервисов |
| Workload | 1         | `node-role=workload` | Для рабочей нагрузки |

### ✅ 3. На инфра-ноду добавлен taint
- **Taint**: `node-role=infra:NoSchedule`
- **Назначение**: Запрещает планирование обычных подов на инфра-ноды

### ✅ 4. Создан S3 бакет для Loki
- **Имя бакета**: `loki-logs-3c548f8b`
- **Storage class**: STANDARD
- **Назначение**: Хранение логов, собираемых Loki

### ✅ 5. Установлен Loki
- **Режим**: Монолитный (single binary)
- **Аутентификация**: `auth_enabled: false`
- **Расположение**: Только на infra-нодах (через nodeAffinity)
- **Обход taint**: Через tolerations

## Результаты выполнения

### Вывод команды: `kubectl get nodes -o wide --show-labels`
\`\`\`
NAME                        STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP      OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME     LABELS
cl16cj4ghvrnrft3b0e9-iwij   Ready    <none>   16m   v1.30.1   10.128.0.21   158.160.38.174   Ubuntu 20.04.6 LTS   5.4.0-216-generic   containerd://1.7.25   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=standard-v2,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=ru-central1-a,kubernetes.io/arch=amd64,kubernetes.io/hostname=cl16cj4ghvrnrft3b0e9-iwij,kubernetes.io/os=linux,node-role=workload,node.kubernetes.io/instance-type=standard-v2,node.kubernetes.io/kube-proxy-ds-ready=true,node.kubernetes.io/masq-agent-ds-ready=true,node.kubernetes.io/node-problem-detector-ds-ready=true,topology.kubernetes.io/zone=ru-central1-a,yandex.cloud/node-group-id=cathp77uoov7f53dojo9,yandex.cloud/pci-topology=k8s,yandex.cloud/preemptible=true
cl16t4bnfm8lret94e4i-ocih   Ready    <none>   15m   v1.30.1   10.128.0.30   46.21.246.160    Ubuntu 20.04.6 LTS   5.4.0-216-generic   containerd://1.7.25   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=standard-v2,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=ru-central1-a,kubernetes.io/arch=amd64,kubernetes.io/hostname=cl16t4bnfm8lret94e4i-ocih,kubernetes.io/os=linux,node-role=infra,node.kubernetes.io/instance-type=standard-v2,node.kubernetes.io/kube-proxy-ds-ready=true,node.kubernetes.io/masq-agent-ds-ready=true,node.kubernetes.io/node-problem-detector-ds-ready=true,topology.kubernetes.io/zone=ru-central1-a,yandex.cloud/node-group-id=cat4octqcjeoci044vj8,yandex.cloud/pci-topology=k8s,yandex.cloud/preemptible=true
\`\`\`

### Вывод команды: `kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints`
\`\`\`
NAME                        TAINTS
cl16cj4ghvrnrft3b0e9-iwij   <none>
cl16t4bnfm8lret94e4i-ocih   [map[effect:NoSchedule key:node-role value:infra]]
\`\`\`

### Вывод команды: `kubectl get pods -n monitoring -o wide`
\`\`\`
NAME                    READY   STATUS    RESTARTS   AGE   IP           NODE                        NOMINATED NODE   READINESS GATES
loki-5db76647d4-z697k   1/1     Running   0          21s   10.1.129.4   cl16t4bnfm8lret94e4i-ocih   <none>           <none>
\`\`\`

### Вывод команды: `yc storage bucket list`
\`\`\`
+--------------------+----------------------+----------+-----------------------+---------------------+
|        NAME        |      FOLDER ID       | MAX SIZE | DEFAULT STORAGE CLASS |     CREATED AT      |
+--------------------+----------------------+----------+-----------------------+---------------------+
| loki-logs-3c548f8b | b1gqbh9n63qaria5u2tj |        0 | STANDARD              | 2025-12-01 16:24:50 |
+--------------------+----------------------+----------+-----------------------+---------------------+
\`\`\`

## Terraform Outputs
\`\`\`
cluster_external_endpoint = "https://51.250.90.137"
cluster_id = "cat711ovkpvsa20g2faa"
infra_node_group_name = "infra-nodes-3c548f8b"
loki_s3_bucket = "loki-logs-3c548f8b"
workload_node_group_name = "workload-nodes-3c548f8b"
\`\`\`

## Примечание
Полный код Terraform и конфигурационные файлы содержат секретные ключи доступа, поэтому не могут быть загружены на GitHub из-за политики безопасности (GitHub Push Protection). Код доступен для проверки локально или по отдельному запросу.

## Скриншоты для проверки
1. S3 бакет в консоли Yandex Cloud (Object Storage)
2. Kubernetes кластер в консоли Yandex Cloud
3. Ноды кластера с labels и taints

---
**Домашнее задание выполнено полностью.** ✅
