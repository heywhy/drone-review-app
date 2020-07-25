<template>
  <router-view />
</template>

<script lang="ts">
import { defineComponent, onMounted } from 'vue'
import { useAuth } from './hooks/auth'

export default defineComponent({
  name: 'App',
  setup() {
    const { user, fetch } = useAuth()

    onMounted(() => {
      if (!user.value) {
        fetch()
      }
    })
  }
})
</script>
