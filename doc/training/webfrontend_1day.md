# Webfrontend実習1日目

## 内容

* 座学・ハンズオンの残り

* `質問詳細ページ(2. コメントの表示)`を実装する。
  * 質問にコメントがついている場合それを表示するように修正する。
  * 下記のファイルを修正する。
    * [Question.vue](../../web/static/components/Question.vue)
    * [Question.spec.js](../../js_test/components/Question.spec.js)
    * [Comment.vue](../../web/static/components/Comment.vue)
    * [Comment.spec.js](../../js_test/components/Comment.spec.js)

* `質問投稿ページ`を実装する。
  * [QuestionCreationPage.vue](../../web/static/pages/QuestionCreationPage.vue)の空実装を実装する。
  * [QuestionCreationPage.spec.js](../../js_test/pages/QuestionCreationPage.spec.js)の空実装を実装する。

## ヒント

* `質問詳細ページ(2. コメントの表示)`に関して、Vueでは`v-for`を利用してテンプレート内で特定のリストに対する繰り返しを実現できる。参照: [List Rendering](https://vuejs.org/v2/guide/list.html)。
```
<div
  v-for="comment in question.comments"
  :key="comment.id">
  <comment
    :comment="comment"
  />
  <hr>
</div>
```

* `質問投稿ページ`はサンプルページである[本の登録ページ(BookCreationPage.vue)](../../web/static/pages/BookCreationPage.vue)を参考にする。
  * ブラウザでパス`#/book/create`で表示できる。
* `質問投稿ページ`はサンプルページである[本の一覧ページ(BookListPage.vue)](../../web/static/pages/BookListPage.vue)を参考にする。
  * ブラウザでパス`#/book`で表示できる。
