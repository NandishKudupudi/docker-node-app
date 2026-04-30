FROM node:18-alpine

# ── 2. Set working directory ────────────────────────
WORKDIR /app

# ── 3. Copy package files FIRST (cache trick) ──────
COPY package*.json ./

# ── 4. Install only production dependencies ────────
RUN npm ci --only=production

# ── 5. Copy rest of source code ─────────────────────
COPY . .

# ── 6. Set environment variable ─────────────────────
ENV NODE_ENV=production

# ── 7. Document port (doesn't publish it) ──────────
EXPOSE 3000

# ── 8. Command to start app ─────────────────────────
CMD ["node", "app.js"]