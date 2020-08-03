import { useHttp } from './http'
import { useLoading } from '../utils'
import { Pagination } from '../models/pagination'
import { Repository } from '../models/repository'

export const useRepositories = () => {
  const { loading, sync } = useLoading()
  const { client } = useHttp()
  const fetchRepositories = (page?: string) => {
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
  const syncRepositories = () => {
    return sync(async () => {
      const { data } = await client.post<null>('/api/repositories/sync')
      return data
    })
  }

  return { loading, syncRepositories }
}

export const useGetRepository = (repo: string) => {
  const { client } = useHttp()
  const { loading, sync } = useLoading()

  const getRepository = () => {
    return sync(async () => {
      const { data } = await client.get<Repository>(`/api/repositories/${repo}`)
      return data
    })
  }

  return { loading, getRepository }
}

export const useActivateRepository = (repo: string) => {
  const { client } = useHttp()
  const { loading, sync } = useLoading()

  const activate = () => {
    return sync(async () => {
      const { data } = await client.patch<Repository>(`/api/repositories/activate`, { repo })
      return data
    })
  }

  return { loading, activate }
}
