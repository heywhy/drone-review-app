module.exports = {
  proxy: {
    // with options
    '/api': {
      target: process.env.VITE_API_URL || 'http://localhost:4000',
      changeOrigin: true,
    }
  }
}
