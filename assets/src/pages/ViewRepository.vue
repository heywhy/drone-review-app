<style scoped>
.tabs {
  > a {
    @apply py-2 px-1 mx-2 uppercase font-medium leading-4;
    &[disabled] {
      pointer-events: none;
      @apply text-gray-400;
    }
    &.router-link-exact-active {
      @apply border-b border-black;
    }
  }
}
</style>

<template>
  <div class="container mx-auto pb-6">
    <div class="page-header">
      <div class="breadcrumbs">
        <div class="breadcrumb-container items-center">
          <router-link class="text-blue-700 link breadcrumb" to="/">Repositories</router-link>
          <arrow-long-icon class="mx-3 align-bottom direction-right text-gray-600 h-5 w-5"/>
        </div>
        <div class="breadcrumb-container">
          <span class="breadcrumb" :title="repo">{{ repo }}</span>
        </div>
      </div>
    </div>

    <div v-if="state.matches('init')" class="mt-3 text-center">Loading Repository</div>

    <template v-else>
      <div class="page-header secondary-page-header">
        <h1 class="font-medium text-2xl leading-7">{{ state.context.repo }}</h1>
      </div>

      <nav class="tabs flex mb-8 px-5 border-b border-gray-300">
        <router-link
          :to="resolveRoute('activities')"
          :disabled="repository && !repository.activated || null"
          exact
        >activities</router-link>
        <router-link
          :to="resolveRoute('branches')"
          :disabled="repository && !repository.activated || null"
          exact
        >branches</router-link>
        <router-link :to="resolveRoute('settings')" exact>settings</router-link>
      </nav>

      <section class="">
        <div class="card p-16">
          <div class="flex justify-center">
            <div v-if="state.matches('activate')" class="py-1 font-medium">Activating...</div>
            <template v-else>
              <button class="btn uppercase p-4" @click="send('ACTIVATE')">activate repository</button>
            </template>
          </div>
        </div>
      </section>
    </template>

  </div>
</template>

<script lang="ts">
import { useRouter } from 'vue-router'
import { defineComponent, computed, ComputedRef, watch } from 'vue'

import { ArrowLongIcon } from '../components/icons'
import { useGetRepository, useActivateRepository } from '../hooks/repository'
import { useMachine } from '@vue/xstate'
import { createMachine, assign } from 'xstate'
import { Repository } from '../models/repository'

type Context = {
  tab: string,
  repo: string,
  namespace: string,
  repository: Repository|null,
}

export default defineComponent({
  components: { ArrowLongIcon },
  setup() {
    const { currentRoute, replace, resolve } = useRouter()
    const { tab, repo, namespace } = currentRoute.value.params
    const { getRepository } = useGetRepository(`${namespace}/${repo}`)
    const { activate: activateRepo } = useActivateRepository(`${namespace}/${repo}`)

    const resolveRoute = (route: string) => {
      const { namespace, repo } = currentRoute.value.params
      return {
        name: 'view:repo',
        params: { repo, namespace, tab: route }
      }
    }

    const allowedRouteGuard = (repository: Repository) => {
      if (repository && !repository.activated) {
        return replace({ name: 'view:repo', params: { repo, namespace, tab: 'settings' } })
      }
    }

    const machine = createMachine<Context>({
      initial: 'init',
      context: {
        repository: null,
        tab: tab as string,
        repo: repo as string,
        namespace: namespace as string,
      },
      states: {
        idle: {
          on: {
            ACTIVATE: 'activate'
          }
        },
        init: {
          invoke: {
            src: getRepository,
            onDone: {
              target: 'idle',
              actions: assign({ repository: (_, { data }) => data }),
            },
          },
        },
        activate: {
          invoke: {
            src: activateRepo,
            onDone: 'init',
          },
        },
      },
    })

    const { send, state } = useMachine(machine)

    watch(() => state.value.context, newVal => {
      const { repository } = newVal
      allowedRouteGuard(repository)
    })

    watch(currentRoute, () => {
      const { repository } = state.value.context
      allowedRouteGuard(repository)
    })

    return {
      send,
      state,
      resolveRoute,
      tab: computed(() => state.value.context.tab),
      repo: computed(() => {
        const { repo, namespace } = state.value.context
        return `${namespace}/${repo}`
      }),
      repository: computed(() => state.value.context.repository),
    }
  }
})
</script>
