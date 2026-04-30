🐳 Dockerized Node.js REST API
A production-ready containerized Express.js REST API demonstrating Docker best practices — multi-stage builds, non-root user, health checks, and DockerHub deployment.

📌 Project Overview
This project solves the classic "works on my machine" problem. By containerizing the application, the same Docker image runs identically across developer laptops, CI pipelines, and cloud servers (AWS EC2 / ECS).

🏗️ Architecture
docker-node-app/
├── app.js              # Express REST API
├── Dockerfile          # Multi-stage production Dockerfile
├── .dockerignore       # Excludes node_modules, .env, .git
├── package.json
└── package-lock.json

⚙️ Tech Stack
ToolPurposeNode.js 18 (Alpine)Runtime — minimal 120MB imageExpress.jsREST API frameworkDockerContainerizationDockerHubPublic image registry

🚀 Quick Start
Option 1 — Pull from DockerHub (no clone needed)
bashdocker run -d -p 3000:3000 nandishkudupudi24/docker-node-app:latest
Option 2 — Clone and build locally
bash# Clone the repo
git clone https://github.com/NandishKudupudi/docker-node-app.git
cd docker-node-app

# Build the image
docker build -t docker-node-app:v1 .

# Run the container
docker run -d -p 3000:3000 --name my-node-app docker-node-app:v1
Test the API
bash# Main endpoint
curl http://localhost:3000
# → {"message":"Hello from Docker container!","version":"1.0.0","environment":"production"}

# Health check
curl http://localhost:3000/health
# → {"status":"OK","uptime":12.3}

🐳 Dockerfile Highlights
dockerfile# Multi-stage build — separates dev and production
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production       # Clean install from lock file
COPY . .

FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app .

ENV NODE_ENV=production
EXPOSE 3000

# Non-root user — security best practice
USER node

# Health check — container self-monitors
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "app.js"]
Key decisions:

node:18-alpine — 120MB vs 900MB for full Debian image
COPY package*.json before COPY . . — Docker layer caching, skips npm install on code-only changes
npm ci — deterministic install from lock file, no version drift
USER node — runs as non-root, reduces attack surface
HEALTHCHECK — orchestrators (ECS, Swarm) auto-restart unhealthy containers


🔧 Useful Docker Commands
bash# View running containers
docker ps

# Follow logs live
docker logs -f my-node-app

# Open shell inside container
docker exec -it my-node-app sh

# Stop and remove
docker stop my-node-app && docker rm my-node-app

# Check image size
docker images docker-node-app

🌐 DockerHub
Image is publicly available on DockerHub:
bashdocker pull nandishkudupudi24/docker-node-app:latest

🔗 hub.docker.com/r/nandishkudupudi24/docker-node-app


🔄 Environment Variables
VariableDefaultDescriptionNODE_ENVproductionApp environmentPORT3000Port the server listens on
Override at runtime:
bashdocker run -d -p 8080:8080 -e PORT=8080 -e NODE_ENV=development docker-node-app:v1

📈 Image Size Comparison
ImageSizenode:18 (Debian)~950MBnode:18-slim~220MBnode:18-alpine (this project)~120MB

💡 What I Learned

Writing production-grade Dockerfiles with multi-stage builds
Docker layer caching strategy to speed up rebuilds
Security hardening — non-root user, minimal base image
Health checks for orchestration readiness
Tagging and pushing images to DockerHub registry

👤 Author
Nandish — Cloud & DevOps Engineer
🔗 GitHub · DockerHub · LinkedIn
