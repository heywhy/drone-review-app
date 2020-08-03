import { createRouter, createWebHistory } from 'vue-router'

import DefaultLayout from './layouts/Default.vue'

export const routerHistory = createWebHistory()
export const router = createRouter({
  history: routerHistory,
  strict: true,
  routes: [
    {
      path: '/',
      component: DefaultLayout,
      children: [
        {
          path: '',
          component: () => import('/src/pages/Home.vue')
        },
        {
          name: 'view:repo',
          path: '/:namespace/:repo/:tab?',
          component: () => import('/src/pages/ViewRepository.vue')
        },
      ],
    },
  ],
})
