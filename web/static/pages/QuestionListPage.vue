<template>
  <div>
    <div class="page-title">質問を見る</div>
    <div>
      <router-link to="question/create">質問する</router-link>
    </div>
    <hr>
    <div
      v-for="question in questions"
      :key="question.id"
    >
      <h5 class="title">
        <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
          {{ question.title }}
        </router-link>
      </h5>
      <div class="additional">
        Posted at {{ question.createdAt }}
        by <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">{{ question.userId }}</router-link>
      </div>
      <hr>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';

export default {
  name: 'QuestionListPage',
  computed: {
    questions() {
      return _.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
  },
  mounted() {
    this.retrieveQuestions();
  },
  methods: {
    retrieveQuestions() {
      this.$store.dispatch('retrieveQuestions');
    },
  },
};
</script>

<style scoped>
.title {
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>
