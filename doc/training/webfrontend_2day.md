# Webfrontend実習2日目

## 内容

* `質問詳細ページ(3. 質問の編集)`を実装する。
  * Handsonで作成した`質問詳細ページ`に対して、自分の質問の場合に編集できるように修正する。
  * 下記のファイルを修正する。
    * [QuestionDetailPage.vue](../../web/static/pages/QuestionDetailPage.vue)
    * [QuestionDetailPage.spec.js](../../js_test/pages/QuestionDetailPage.spec.js)
    * [Question.vue](../../web/static/components/Question.vue)
    * [Question.spec.js](../../js_test/components/Question.spec.js)

* `質問詳細ページ(4. 質問へのコメントの追加・編集)`を実装する。
  * 作成済みの`質問詳細ページ`に対して、ログイン済みの自分や他のユーザーが質問へのコメントを追加し、追加した人がコメントを編集できるようにする。
  * 下記のファイルを修正する。
    * [Question.vue](../../web/static/components/Question.vue)
    * [Question.spec.js](../../js_test/components/Question.spec.js)
    * [Comment.vue](../../web/static/components/Comment.vue)
    * [Comment.spec.js](../../js_test/components/Comment.spec.js)
  * お手本にはコメントの追加時にアニメーションがあるが対応は不要。余裕があればオプショナル課題として好きなエフェクトを追加していい。

## ヒント
