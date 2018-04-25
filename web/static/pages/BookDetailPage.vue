<template>
  <div>
    <div v-if="!hasValidBook">
      読み込み中。
    </div>
    <div v-else>
      <book
        :book="book"
        class="book"
        @update="updateBook"
      />
    </div>
    <hr>
    <router-link :to="{ name: 'BookListPage'}">
      一覧に戻る
    </router-link>
  </div>
</template>

<script>
import _ from 'lodash';
import Book from '@/components/Book';

export default {
  name: 'BookDetailPage',
  components: {
    Book,
  },
  computed: {
    hasValidBook() {
      return !_.isEmpty(this.book);
    },
    book() {
      return this.$store.state.book;
    },
  },
  mounted() {
    this.retrieveBook();
  },
  methods: {
    retrieveBook() {
      this.$store.dispatch('retrieveBook', { id: this.$route.params.id });
    },
    updateBook({ title, author }) {
      this.$store.dispatch('updateBook', { id: this.$route.params.id, title, author });
    },
  },
};
</script>

<style scoped>
.book {
  margin-bottom: 20px;
}
</style>
