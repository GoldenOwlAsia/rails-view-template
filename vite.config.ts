import { defineConfig } from 'vite';
import ViteRails from 'vite-plugin-rails';
import path from 'path';

export default defineConfig({
  plugins: [
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
      '@': path.resolve(__dirname, 'app/frontend'),
    },
  },
});
