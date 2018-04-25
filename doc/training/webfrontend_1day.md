# Webfrontend実習1日目

## 内容

* `質問投稿ページ`を実装する。
  * [QuestionCreationPage.vue](../../web/static/pages/QuestionCreationPage.vue)の空実装を実装する。
  * [QuestionCreationPage.spec.js](../../js_test/pages/QuestionCreationPage.spec.js)の空実装を実装する。

* `質問詳細ページ(2. 質問の編集)`を実装する。
  * Handsonで作成した`質問詳細ページ`に対して、自分の質問の場合に編集できるように修正する。
  * 下記のファイルを修正する。
    * [QuestionDetailPage.vue](../../web/static/pages/QuestionDetailPage.vue)
    * [QuestionDetailPage.spec.js](../../js_test/pages/QuestionDetailPage.spec.js)
    * [Question.vue](../../web/static/components/Question.vue)
    * [Question.spec.js](../../js_test/components/Question.spec.js)

## ヒント

* `質問投稿ページ`はサンプルページである[本の登録ページ(BookCreationPage.vue)](../../web/static/pages/BookCreationPage.vue)を参考にする。
  * ブラウザでパス`#/book/create`で表示できる。
* `質問投稿ページ`はサンプルページである[本の一覧ページ(BookListPage.vue)](../../web/static/pages/BookListPage.vue)を参考にする。
  * ブラウザでパス`#/book`で表示できる。
