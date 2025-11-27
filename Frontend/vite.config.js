import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  base: '/cicd_weatherApp/',
  server: {
    port: 4836,
    proxy: {
      '/api': {
        target: 'http://localhost:6384',
        changeOrigin: true,
        secure: false,
      },
      '/auth': {
        target: 'http://localhost:6384',
        changeOrigin: true,
        secure: false,
      }
    }
  }
})
