<template>
  <div>
    <div v-if="hasValidQuestion">
      <question :question="question"/>
    </div>
    <h1 v-else>404 (Not Found)</h1>
  </div>
</template>

<script>
import _ from 'lodash';
import Question from '@/components/Question';
import Comment from '@/components/Comment';
import Answer from '@/components/Answer';

export default {
  name: 'QuestionDetailPage',
  components: {
    Question,
    Comment,
    Answer,
  },
  data() {
    return {};
  },
  computed: {
    hasValidQuestion() {
      return !_.isEmpty(this.question) && this.question.id === this.$route.params.id;
    },
    question() {
      return this.$store.state.question;
    },
  },
  mounted() {
    this.retrieveQuestion();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
    // TODO ADD ANSWER, COMMENT and LIKE/DISLIKE function
  },
};
</script>

<style scoped>
</style>
