# Deployment Guide

This guide covers production deployment options for the OpenClaw Telegram Learning Assistant.

## Deployment Options

### Option 1: Docker on VPS (Recommended)

Best for: Personal use, small teams, privacy-conscious deployments

#### Step 1: Provision VPS
- Recommended: Ubuntu 22.04 LTS
- Minimum: 4GB RAM, 20GB disk (8GB RAM, 30GB for comfort)
- Providers: DigitalOcean, Linode, Hetzner, AWS EC2

#### Step 2: Install Dependencies
```bash
# SSH into server
ssh root@your_server_ip

# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install -y docker-compose

# Add your user to docker group (optional)
usermod -aG docker $USER
newgrp docker
```

#### Step 3: Clone Repository
```bash
git clone https://github.com/yourusername/openclaw-telegram-learning-assistant.git
cd openclaw-telegram-learning-assistant
```

#### Step 4: Configure Environment
```bash
cp .env.example .env
# Edit and set your token
nano .env
```

#### Step 5: Deploy
```bash
# Build and start
docker-compose up -d

# View logs
docker-compose logs -f openclaw-gateway

# Check status
docker-compose ps
```

#### Step 6: Setup Auto-Start
```bash
# Create systemd service
sudo tee /etc/systemd/system/openclaw.service > /dev/null <<EOF
[Unit]
Description=OpenClaw Telegram Learning Assistant
After=docker.service
Requires=docker.service

[Service]
Type=simple
WorkingDirectory=/root/openclaw-telegram-learning-assistant
ExecStart=/usr/bin/docker-compose up
ExecStop=/usr/bin/docker-compose down
Restart=unless-stopped
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw
```

#### Step 7: Monitor
```bash
# Check service status
systemctl status openclaw

# View real-time logs
journalctl -u openclaw -f

# Check gateway health
curl http://localhost:8080/health
```

---

### Option 2: Kubernetes (Advanced)

Best for: Large-scale, high-availability deployments

#### Deployment Manifests

Create `k8s/deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: openclaw-gateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: openclaw
  template:
    metadata:
      labels:
        app: openclaw
    spec:
      containers:
      - name: gateway
        image: openclaw:latest
        ports:
        - containerPort: 8080
        env:
        - name: TELEGRAM_BOT_TOKEN
          valueFrom:
            secretKeyRef:
              name: openclaw-secrets
              key: telegram-token
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
      - name: ollama
        image: ollama/ollama:latest
        ports:
        - containerPort: 11434
        volumeMounts:
        - name: ollama-data
          mountPath: /root/.ollama
      volumes:
      - name: ollama-data
        persistentVolumeClaim:
          claimName: ollama-pvc
```

Create `k8s/service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: openclaw-service
spec:
  selector:
    app: openclaw
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
```

Deploy:
```bash
kubectl apply -f k8s/
kubectl logs -f deployment/openclaw-gateway
```

---

### Option 3: Cloud Run / Managed Services

Best for: Serverless, minimal ops overhead

#### Google Cloud Run
```bash
# Build image
gcloud builds submit --tag gcr.io/PROJECT_ID/openclaw

# Deploy
gcloud run deploy openclaw \
  --image gcr.io/PROJECT_ID/openclaw \
  --platform managed \
  --region us-central1 \
  --set-env-vars TELEGRAM_BOT_TOKEN=your_token
```

#### AWS ECS
```bash
# Create task definition
aws ecs register-task-definition \
  --family openclaw \
  --container-definitions file://task-def.json

# Create service
aws ecs create-service \
  --cluster my-cluster \
  --service-name openclaw \
  --task-definition openclaw
```

---

## Monitoring & Maintenance

### Health Checks
```bash
# Gateway health
curl http://your-server:8080/health

# Ollama status
curl http://your-server:11434/api/tags

# Check specific endpoint
curl -X GET http://your-server:8080/status
```

### Logging
```bash
# Docker compose
docker-compose logs --tail 100 -f

# Kubernetes
kubectl logs -f deployment/openclaw-gateway --all-containers

# System logs
journalctl -u openclaw -f --lines 50
```

### Backup Strategy

```bash
#!/bin/bash
# Backup memory and config daily

BACKUP_DIR="/backups/openclaw"
mkdir -p $BACKUP_DIR

# Backup memory
docker cp openclaw-gateway:/root/.openclaw/memory \
  $BACKUP_DIR/memory-$(date +%Y%m%d)

# Backup config
cp ~/.openclaw/openclaw.json \
  $BACKUP_DIR/openclaw-$(date +%Y%m%d).json

# Keep last 30 days
find $BACKUP_DIR -mtime +30 -delete

# Upload to S3 (optional)
aws s3 sync $BACKUP_DIR s3://my-backups/openclaw/
```

Schedule with cron:
```bash
# Add to crontab
0 2 * * * /path/to/backup-openclaw.sh
```

---

## SSL/TLS Setup

For secure gateway access:

```bash
# Using Let's Encrypt with Docker
docker run --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/www/certbot:/var/www/certbot" \
  certbot/certbot certonly --standalone \
  -d your-domain.com

# Update docker-compose.yml to use certificates
```

---

## Performance Tuning

### Ollama
```bash
# Increase context window
export OLLAMA_NUM_PARALLEL=4
export OLLAMA_NUM_THREAD=8

# Use GPU
docker-compose.yml: runtime: nvidia
```

### Memory Optimization
```json
{
  "model": {
    "temperature": 0.7,
    "maxTokens": 1500,
    "contextWindow": 2048
  }
}
```

---

## Troubleshooting Deployment

### "Container won't start"
```bash
docker-compose logs openclaw-gateway
docker-compose ps
```

### "Telegram token not recognized"
```bash
# Verify token
echo $TELEGRAM_BOT_TOKEN
grep TELEGRAM .env

# Restart service
docker-compose restart openclaw-gateway
```

### "High memory usage"
```bash
# Monitor
docker stats openclaw-gateway

# Reduce model size
# Use smaller model: gemma:2b instead of llama3:8b
# Reduce context window in config
```

---

## Production Checklist

- [ ] Secrets stored in environment variables (not committed)
- [ ] Automatic backups configured
- [ ] Health checks monitoring
- [ ] Log aggregation setup
- [ ] Resource limits defined
- [ ] Restart policies configured
- [ ] SSL/TLS configured
- [ ] Rate limiting configured
- [ ] Regular updates scheduled
- [ ] Incident response plan

---

For questions or issues during deployment, check the main README.md or create an issue on GitHub.
