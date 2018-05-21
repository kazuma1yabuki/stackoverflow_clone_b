<template>
  <div>
    <div class="page-title">質問を投稿する</div>
    <form
      class="question-form"
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
        <label for="form-body">内容</label>
        <textarea
          id="form-body"
          v-model="body"
          :maxlength="bodyMaxLength"
          class="body-edit form-control"
          type="text"
          minlength="1"
          required/>
      </div>
      <div class="form-group">
        <button
        class="btn btn-primary mb-2"
        type="submit">投稿</button>
      </div>
    </form>
    <hr>
    <router-link :to="{ name: 'QuestionListPage'}">
      一覧に戻る
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'QuestionCreationPage',
  data(){
    return{
      title: '',
      body: '',
    };
  },
  methods: {
// 上のtype="submit"での操作
    submit() {
      this.$store.dispatch('createQuestion', { title: this.title, body: this.body })
        .then(() => {
          this.$router.push({ path: '/' });
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
