# ddmer-1 部署踩坑记录

## 问题：Nginx 缓存导致 Mixed Content 错误

### 症状

部署到服务器后，浏览器访问出现大量混合内容错误：

```
Mixed Content: The page at 'https://[你的域名]/' was loaded over HTTPS,
but requested an insecure resource 'http://[你的域名]:8000/api/posts/count?status=published'.
This request has been blocked; the content must be served over HTTPS.
```

关键现象：
- 编译产物里**完全没有** `http://[你的域名]:8000` 或 `localhost:8000`
- `curl https://[你的域名]/api/health` 返回正常，Nginx 反代正常
- 浏览器控制台 `fetch('/api/albums')` 能成功返回数据
- 清除浏览器缓存、无痕模式、换浏览器都不行
- 只有首页出问题，其他页面刷新后正常

### 根因

**Nginx 缓存了旧的 HTML 页面。**

每次 `pnpm build` 后，Next.js 会生成新的 chunk 文件名（带 hash），比如：
- 旧：`0.yx~-n01gczc.js`
- 新：`0s4-wrpdah-.i.js`

旧 HTML 页面引用旧 chunk 文件名。重新部署后：
1. 新的 `.next` 文件夹里是新 chunk 文件
2. 但 Nginx 还在返回缓存的旧 HTML
3. 浏览器加载旧 HTML → 请求旧 chunk 文件名 → 文件不存在 → 报错

### 解决方案

在 Nginx 配置的 `location /` 块中**禁用代理缓存**：

```nginx
location / {
    proxy_pass http://127.0.0.1:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    # 关键：禁用 Nginx 代理缓存，否则部署后会返回旧 HTML
    proxy_no_cache 1;
    proxy_cache_bypass 1;
    proxy_cache off;
    add_header Cache-Control "no-cache, no-store, must-revalidate";
    add_header Pragma "no-cache";
    add_header Expires "0";

    proxy_connect_timeout 30s;
    proxy_read_timeout 86400s;
    proxy_send_timeout 30s;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}
```

修改后重载 Nginx：
```bash
nginx -s reload
```

---

## API 代理方案

### 推荐方案：Next.js rewrites + Nginx 反代

**不要用环境变量拼接 API 地址**，改用 `next.config.ts` 的 `rewrites`：

```typescript
// next.config.ts
const nextConfig: NextConfig = {
  async rewrites() {
    return [
      { source: "/api/:path*", destination: "http://127.0.0.1:8000/api/:path*" },
      { source: "/uploads/:path*", destination: "http://127.0.0.1:8000/uploads/:path*" },
    ];
  },
  // ...
};
```

```typescript
// siteConfig.ts
apiBaseUrl: "",  // 硬编码空字符串，不用环境变量
```

**请求流程：**

- **开发环境**（`pnpm dev`）：
  ```
  浏览器 → fetch("/api/posts") → Next.js dev server → rewrites 代理 → http://127.0.0.1:8000
  ```

- **生产环境**（服务器）：
  ```
  浏览器 → fetch("/api/posts") → Nginx location /api/ → proxy_pass http://127.0.0.1:8000
  ```
  （请求根本到不了 Next.js，Nginx 直接转发给后端）

### 为什么不用环境变量

`process.env.NEXT_PUBLIC_API_URL` 在 Next.js 的 SSR/客户端构建中行为不一致：
- 空字符串 `NEXT_PUBLIC_API_URL=` 可能被当作 `undefined`
- `??` 和 `||` 对空字符串的处理不同
- 服务端渲染和客户端渲染可能用不同的值
- 打包后值被内联到 JS 中，无法运行时修改

---

## 服务器环境

- **服务器**：[你的服务器配置]
- **面板**：[你的面板，如宝塔面板]
- **前端**：Next.js，端口 3000
- **后端**：Next.js API Routes + SQLite（无需额外后端服务）
- **Nginx**：反向代理，`/` → 3000
- **Node.js 启动命令**：`next start`（生产模式）

### 注意事项

1. **Nginx 必须禁用缓存**，否则部署后会返回旧 HTML
2. **服务器内存紧张**时，Next.js 进程可能占 500MB+，可加 `NODE_OPTIONS=--max-old-space-size=512` 限制内存
3. **宝塔面板的 Node 项目管理器**可能有自己的缓存机制，重启项目后确认进程 PID 更新
4. 部署后用 `curl -s https://[你的域名]/ | grep buildId` 确认返回的是最新构建
