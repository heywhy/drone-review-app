import { ref } from 'vue'

export const sleep = (seconds: number) => new Promise(resolve => setTimeout(resolve, seconds * 1000))

export const useLoading = () => {
  const loading = ref(false)
  const update = (isLoading: boolean) => loading.value = isLoading
  const start = () => update(true)
  const stop = () => update(false)
  const sync = async <T = void>(cb: () => T|Promise<T>) => {
    start()
    let result = cb()
    if (result instanceof Promise) result = await result
    stop()
    return result
  }

  return { loading, start, stop, sync }
}
