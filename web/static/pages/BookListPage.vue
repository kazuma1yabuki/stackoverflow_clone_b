<template>
  <div>
    <div class="page-title">本の一覧</div>
    <div>
      <router-link to="book/create">本を登録する</router-link>
    </div>
    <hr>
    <div
      v-for="book in books"
      :key="book.id"
    >
      <h5 class="title">
        <router-link :to="{ name: 'BookDetailPage', params: { id: book.id }}">
          {{ book.title }}
        </router-link>
      </h5>
      <div class="additional">
        {{ book.author }}
      </div>
      <hr>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';

export default {
  name: 'BookListPage',
  computed: {
    books() {
      return _.sortBy(this.$store.state.books, 'createdAt').reverse();
    },
  },
  mounted() {
    this.retrieveBooks();
  },
  methods: {
    retrieveBooks() {
      this.$store.dispatch('retrieveBooks');
    },
  },
};
</script>

<style scoped>
.title, .additional {
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>
