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
  <div class="container mx-auto pb-6 lg:px-24">
    <div class="px-4 flex justify-between">
      <span class="text-sm font-light">Repositories</span>

      <button class="btn uppercase" :disabled="state.matches('sync')" @click="send('SYNC_REPOS')">
        <CWIcon class="h-5 w-5" :class="{spinning: state.matches('sync')}" />
        <span class="ml-2">sync</span>
      </button>
    </div>

    <div v-if="state.matches('init')" class="mt-3 text-center">Loading...</div>

    <div class="mt-4">
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
      <button class="btn flat btn--show-more" @click="send('FETCH_MORE')">
        <arrow-long-down-icon class="h-5 w-5" />
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
import { useRepositories, useSyncRepositories } from '../hooks/repository'
import { CWIcon, GithubIcon, ArrowLongDownIcon } from '../components/icons'

type Context = {
  repositories: Repository[],
  metadata: PaginationMetadata|null,
}

export default defineComponent({
  components: { CWIcon, GithubIcon, ArrowLongDownIcon },
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
            FETCH_MORE: 'fetch',
            SYNC_REPOS: 'sync',
          },
        },
        init: {
          invoke: {
            src: () => fetchRepositories(),
            onDone: onFetchDone,
          },
        },
        fetch: {
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
