module.exports = {
  alias: {
    '@vue/xstate': '/src/xstate'
  },
  proxy: {
    // with options
    '/auth': {
      target: process.env.VITE_API_URL || 'http://localhost:4000',
      changeOrigin: true,
    },
    '/api': {
      target: process.env.VITE_API_URL || 'http://localhost:4000',
      changeOrigin: true,
    }
  }
}
