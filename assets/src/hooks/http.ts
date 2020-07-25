import axios from 'axios'
import { useAuth } from './auth'

let interceptorId: number
let isIntercepted = false
const client = axios.create()

export const useHttp = () => {
  const { user } = useAuth()
  if (!isIntercepted && user.value?.api_token) {
    interceptorId = client.interceptors.request.use(request => {
      const { headers } = request
      headers.Authorization = `Bearer ${user.value.api_token}`
      return request
    })
    isIntercepted = true
  }

  return { client }
}
