export type PaginationMetadata = {
  after: string|null,
  before: string|null,
  limit: number,
  total_count: number,
  total_count_cap_exceeded: boolean,
}

export type Pagination<T> = {
  entries: T[],
  metadata: PaginationMetadata,
}
