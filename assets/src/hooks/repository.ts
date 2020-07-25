import { ref } from 'vue'
import { useHttp } from './http'
import { useLoading } from '../utils'
import { Pagination } from '../models/pagination'
import { Repository } from '../models/repository'

export const useRepositories = () => {
  const { loading, sync } = useLoading()
  const { client } = useHttp()
  const fetchRepositories = async (page?: string) => {
    return sync(async () => {
      const { data } = await client.get<Pagination<Repository>>('/api/repositories', {
        params: { page }
      })
      return data
    })
  }

  return { loading, fetchRepositories }
}

export const useSyncRepositories = () => {
  const { loading, sync } = useLoading()
  const { client } = useHttp()
  const syncRepositories = async () => {
    return sync(async () => {
      const { data } = await client.post<null>('/api/repositories/sync')
      return data
    })
  }

  return { loading, syncRepositories }
}
