<template>
  <header class="flex justify-between items-center px-4 py-2 bg-gray-900">
    <div class="w-auto font-semibold text-gray-100 text-lg">ReviewApp</div>

    <template v-if="user">
      <div class="flex-grow px-2" style="height: 3.125rem;">
        <div class="py-1 w-full h-full flex justify-center">
          <input
            ref="inputRef"
            type="search"
            @keydown.esc="inputRef.blur()"
            @focus="isSearchActive = true"
            @blur="isSearchActive = false"
            class="repo--search-input"
            :class="{ active: isSearchActive }"
            placeholder="Search for repositories to jump to.."
          />
        </div>
        <div v-show="isSearchActive" class="overlay dimmed"></div>
      </div>

      <div class="w-auto">
        <div>
          <div class="text-right relative">
            <img
              class="cursor-pointer inline-block h-8 w-8 rounded-full hover:border-gray-500 border object-cover object-center focus:outline-none"
              @click="isAccountMenuOpened = !isAccountMenuOpened"
              :src="user.avatar_url"
            />
            <div v-show="isAccountMenuOpened">
              <div class="overlay" @click="isAccountMenuOpened = false"></div>

              <div class="absolute right-0 mt-1">
                <div class="bg-white shadow-md rounded" style="min-width: 15.625rem;">
                  <div class="text-center p-4">
                    <img
                      :src="user.avatar_url"
                      class="inline-block h-16 w-16 rounded-full object-cover object-center focus:outline-none"
                    />
                    <span class="block mt-2 text-gray-800 font-light">{{ user.name }}</span>
                    <span class="block mt-1 text-gray-500 font-light">{{ user.email }}</span>
                  </div>

                  <div class="mt-1">
                    <a href="#" class="flex items-center py-2 px-3 text-gray-800 font-light border-t hover:bg-gray-100">
                      <cog-icon class="h-5 w-5" />
                      <span class="ml-2">Account settings</span>
                    </a>
                    <a href="#" class="flex items-center py-2 px-3 text-gray-800 font-light border-t hover:bg-gray-100">
                      <bell-icon class="h-5 w-5" />
                      <span class="ml-2 leading-tight">Notifications</span>
                    </a>
                    <a href="#" class="flex items-center py-2 px-3 text-gray-800 font-light border-t hover:bg-gray-100">
                      <logout-icon class="h-5 w-5" />
                      <span class="ml-2">Sign out</span>
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </template>
    <div v-else class="flex justify-end">
      <a href="/auth/github" class="btn text-gray-200">
        <github-icon class="h-5 w-5" />
        <span class="ml-2">Sign in</span>
      </a>
    </div>
  </header>

</template>

<script lang="ts">
import { defineComponent, ref, onMounted, watch, onUnmounted, onUpdated } from 'vue'
import * as Icons from '../icons'
import { useMachine } from '@vue/xstate'
import { useAuth } from '../../hooks/auth'
import { useHotKeys } from '../../hooks/keyboard'

export default defineComponent({
  components: { ...Icons },
  setup() {
    const inputRef = ref(null)
    const isSearchActive = ref(false)
    const isAccountMenuOpened = ref(false)
    const { user } = useAuth()

    useHotKeys('esc', () => isAccountMenuOpened.value = false)

    return {
      user,
      inputRef,
      isSearchActive,
      isAccountMenuOpened,
    }
  }
})
</script>
