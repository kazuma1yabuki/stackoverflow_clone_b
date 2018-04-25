<template>
  <div>
    <div v-if="editing">
      <div class="form-group">
        <label for="form-title">タイトル</label>
        <input
          id="form-title"
          v-model="editingTitle"
          :maxlength="titleMaxLength"
          class="title-edit form-control"
          type="text"
          minlength="1"
          required>
      </div>
    </div>
    <div v-else>
      <div class="page-title">{{ book.title }}</div>
    </div>
    <hr>
    <div class="main-area">
      <div class="content-area">
        <div v-if="editing">
          <form
            class="book-form"
            @submit.prevent="update">
            <div class="form-group">
              <label for="form-author">著者</label>
              <input
                id="form-author"
                v-model="editingAuthor"
                :maxlength="authorMaxLength"
                class="author-edit form-control"
                type="text"
                minlength="1"
                required>
            </div>
            <div class="form-group">
              <button
                class="btn btn-primary mb-2"
                type="submit">保存</button>
              <button
                class="cancel-edit-button btn btn-outline-primary mb-2"
                type="submit"
                @click.prevent="cancelEdit">キャンセル</button>
            </div>
          </form>
        </div>
        <div v-else>
          <div
            class="author"
          >
            著者: {{ book.author }}
          </div>
          <div class="additional">
            <span v-if="!editing">
              <button
                type="button"
                class="edit-button btn btn-link"
                @click="startEdit"
              >
                更新
              </button>
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Book',
  props: {
    book: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      newCommentauthor: '',
      editing: false,
      editingAuthor: '',
      editingTitle: '',
    };
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingAuthor = this.book.author;
      this.editingTitle = this.book.title;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      this.$emit('update', { title: this.editingTitle, author: this.editingAuthor });
      this.editing = false;
    },
  },
};
</script>

<style scoped>
.page-title {
  text-overflow: ellipsis;
  overflow: hidden;
}
.author {
  word-break: break-all;
  white-space: pre-wrap;
}
.comment-list {
  margin-left: 10px;
}
</style>
