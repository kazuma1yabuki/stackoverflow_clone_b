# Webfrontend実習3日目

## 内容

* `質問詳細ページ(5. 回答の表示・追加・編集。回答へのコメントの追加・編集)`を実装する。
  * 作成済みの`質問詳細ページ`に対して、ログイン済みの自分や他のユーザーが回答の追加や編集、回答へのコメントの追加・編集をできるようにする。
  * 下記のファイルを修正する。
    * [QuestionDetailPage.vue](../../web/static/pages/QuestionDetailPage.vue)
    * [QuestionDetailPage.spec.js](../../js_test/pages/QuestionDetailPage.spec.js)
    * [Answer.vue](../../web/static/components/Answer.vue)
    * [Answer.spec.js](../../js_test/components/Answer.spec.js)

## ヒント

* コメントの実装は質問へのコメントと同じコンポーネント([Comment.vue](../../web/static/components/Comment.vue))を利用できる。ただ、別にファイルを作成しても構わない。
  * 共通にする場合、更新処理は異なるため、Commnetからeventをemitして、親(Question, Answer)でハンドルして更新する必要がある。
