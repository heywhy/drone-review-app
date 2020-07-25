<style scoped>
.page {
  padding-top: 5.875rem;
  @apply px-4;
}
</style>

<template>
  <div class="bg-gray-200 min-h-screen">
    <app-bar class="fixed inset-x-0 top-0" />
    <main class="page">
      <router-view />
    </main>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import AppBar from '../components/navigation/AppBar.vue'

export default defineComponent({
  name: 'App',
  components: { AppBar },
})
</script>
