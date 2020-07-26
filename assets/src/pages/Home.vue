<style scoped>
.btn--show-more {
  @apply text-blue-600;
  &:hover {
    span {
      @apply border-b border-blue-600;
    }
  }
}
</style>

<template>
  <div class="container mx-auto pb-6">
    <div class="page-header">
      <div class="breadcrumbs">
        <div class="breadcrumb-container">
          <span class="font-light breadcrumb">Repositories</span>
        </div>
      </div>

      <button class="btn uppercase" :disabled="state.matches('sync')" @click="send('SYNC_REPOS')">
        <CWIcon class="h-5 w-5" :class="{spinning: state.matches('sync')}" />
        <span class="ml-2">sync</span>
      </button>
    </div>

    <div v-if="state.matches('init')" class="mt-3 text-center">Loading...</div>

    <div>
      <router-link
        v-for="repo in repositories"
        :key="repo.node_id"
        :to="`${repo.full_name}/settings`"
        class="flex items-center p-4 mb-3 cursor-pointer bg-white rounded shadow hover:shadow-md"
      >
        <div class="">
          <github-icon class="h-5 w-5" />
        </div>
        <div class="px-2 text-lg" :class="{'text-blue-600': repo.activated, 'text-gray-600': !repo.activated}">
          {{ repo.full_name }}
        </div>
      </router-link>
    </div>

    <div v-if="!!metadata && metadata.after" class="pl-2 mt-4">
      <button class="btn flat btn--show-more" @click="send('FETCH_MORE_REPOS')">
        <arrow-long-icon class="h-5 w-5" />
        <span class="ml-1 text-sm font-light">Show more repositories</span>
      </button>
    </div>
  </div>

</template>

<script lang="ts">
import { useMachine } from '@vue/xstate'
import { defineComponent, ref, onMounted, watch, computed } from 'vue'
import { createMachine, assign, EventObject, TransitionConfig, DoneInvokeEvent } from 'xstate'

import { Repository } from '../models/repository'
import { PaginationMetadata, Pagination } from '../models/pagination'
import { CWIcon, GithubIcon, ArrowLongIcon } from '../components/icons'
import { useRepositories, useSyncRepositories } from '../hooks/repository'

type Context = {
  repositories: Repository[],
  metadata: PaginationMetadata|null,
}

export default defineComponent({
  components: { CWIcon, GithubIcon, ArrowLongIcon },
  setup() {
    const { fetchRepositories } = useRepositories()
    const { syncRepositories } = useSyncRepositories()

    const onFetchDone: TransitionConfig<Context, DoneInvokeEvent<Pagination<Repository>>> = {
      target: 'idle',
      actions: assign({
        metadata: (_, { data }) => data.metadata,
        repositories: ({ repositories }, { data: { entries } }) => ([...repositories, ...entries])
      })
    }

    const machine = createMachine<Context>({
      initial: 'init',
      context: {
        metadata: null,
        repositories: [],
      },
      states: {
        idle: {
          on: {
            FETCH_MORE_REPOS: 'fetchMore',
            SYNC_REPOS: 'sync',
          },
        },
        init: {
          invoke: {
            src: () => fetchRepositories(),
            onDone: onFetchDone,
          },
        },
        fetchMore: {
          invoke: {
            src: ({ metadata }) => fetchRepositories(metadata.after),
            onDone: onFetchDone,
          },
        },
        sync: {
          invoke: {
            src: syncRepositories,
            onDone: {
              target: 'init',
              actions: assign({ repositories: () => ([]) }),
            },
          },
        },
      },
    })

    const { send, state } = useMachine(machine)

    return {
      send,
      state,
      metadata: computed(() => state.value.context.metadata),
      repositories: computed(() => state.value.context.repositories),
    }
  },
})
</script>
