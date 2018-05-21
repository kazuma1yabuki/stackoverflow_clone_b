<template>
  <div>
    comment:<div class="body">{{ comment.body }}</div>
            <div class="id">{{ comment.userId }}</div>
            <!-- <h5 class="id">
              <router-link :to="{ name: 'QuestionDetailPage', params: { id: comment.userId }}">
                {{ question.title }}
              </router-link>
            </h5> -->
  </div>
</template>

<script>
export default {
  name: 'Comment',
  props: {
    comment: {
      type: Object,
      required: true,
    },
  },

};
</script>

<style scoped>
</style>
