<template>
  <div>
    <div class="page-title">本を登録する</div>
    <form
      class="book-form"
      @submit.prevent="submit">
      <div class="form-group">
        <label for="form-title">タイトル</label>
        <input
          id="form-title"
          v-model="title"
          :maxlength="titleMaxLength"
          class="title-edit form-control"
          type="text"
          minlength="1"
          required>
      </div>
      <div class="form-group">
        <label for="form-author">著者</label>
        <textarea
          id="form-author"
          v-model="author"
          class="author-edit form-control"
          minlength="1"
          maxlength="50"
          required/>
      </div>
      <div class="form-group">
        <button
          class="btn btn-primary mb-2"
          type="submit">投稿</button>
      </div>
    </form>
    <hr>
    <router-link :to="{ name: 'BookListPage'}">
      一覧に戻る
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'BookCreationPage',
  data() {
    return {
      title: '',
      author: '',
    };
  },
  methods: {
    submit() {
      this.$store.dispatch('createBook', { title: this.title, author: this.author })
        .then(() => {
          this.$router.push({ path: '/book' });
        });
    },
  },
};
</script>

<style scoped>
.author-edit {
  height: 140px;
}
</style>
