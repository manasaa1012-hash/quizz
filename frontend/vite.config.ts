import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, ".", "VITE_");
  return {
    plugins: [react()],
    server: {
      port: 5173,
      proxy: {
        "/api": {
          target: env.VITE_API_PROXY_TARGET || "http://127.0.0.1:5000",
          changeOrigin: true,
          // Browser requests stay on the frontend origin. The local proxy
          // connects to the backend without forwarding the browser's LAN origin.
          configure(proxy) {
            proxy.on("proxyReq", (proxyReq) => proxyReq.removeHeader("origin"));
          }
        }
      }
    }
  };
});
