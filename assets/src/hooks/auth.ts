import axios from 'axios'
import { ref } from 'vue'

const user = ref()

export const useAuth = () => {
  const loading = ref(false)

  const fetch = async () => {
    loading.value = true
    try {
      const { data } = await axios.get('/api/me')
      user.value = data
    } catch(e) {
      console.error(e)
    }
    loading.value = false
  }

  return { loading, user, fetch }
}
