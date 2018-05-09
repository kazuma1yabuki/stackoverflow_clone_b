<template>
  <div>
    <div class="page-title">{{ question.title }}</div>
    <div class="body">{{ question.body }}</div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Question',
  components: {
    Comment,
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {};
  },
  methods: {

  },
};
</script>

<style scoped>
</style>
