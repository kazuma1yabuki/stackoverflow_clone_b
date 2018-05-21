<template>
  <div>
    <div class="page-title">{{ question.title }}</div>
    <div class="body">{{ question.body }}</div>
    <div class="id">{{question.id}}</div>
    <div class="additional">
      Posted at {{ question.createdAt }}
      by <router-link :to="{ name: 'UserDetailPage', params: { id: question.Id }}">{{ question.userId }}</router-link>
    </div>
    <div
  v-for="comment in question.comments"
  :key="comment.id">
  <hr>
  <comment
    :comment="comment"
  />
</div>
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
