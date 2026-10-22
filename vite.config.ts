import { defineConfig } from 'vite';
import { fileURLToPath, URL } from 'url';
import ViteRails from 'vite-plugin-rails';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [
    tailwindcss(),
    ViteRails({
      envVars: { RAILS_ENV: 'development' },
      envOptions: { defineOn: 'import.meta.env' },
      fullReload: {
        additionalPaths: [],
      },
    }),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./app/frontend', import.meta.url)),
    },
  },
});
