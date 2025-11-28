import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { resolve } from 'path'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  base: '/cicd_weatherApp/',
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        world: resolve(__dirname, 'world.html'),
        search: resolve(__dirname, 'search.html'),
      },
    },
  },
  server: {
    port: 4837,
    proxy: {
      '/api': {
        target: 'http://localhost:6385',
        changeOrigin: true,
        secure: false,
      },
      '/auth': {
        target: 'http://localhost:6385',
        changeOrigin: true,
        secure: false,
      }
    }
  }
})
