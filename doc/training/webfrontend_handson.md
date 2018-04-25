# Webfrontend開発ハンズオン

## 内容

* 今後作成するものを理解する。
* ツールの概要・使い方を理解する。
* Vueの使い方を理解する。
* `質問詳細ページ(1.質問とコメントの表示)`を実装する。

## 利用しているツールの説明

### 開発環境用のツール・ライブラリ

* [Yarn](https://yarnpkg.com/en/)
  * パッケージマネージャー。
* [Node.js](https://nodejs.org/en/)
  * ブラウザを使わないJavaScriptの実行環境。このプロジェクトではYarnの実行やユニットテストの実行環境に利用する。
* [Webpack](https://webpack.js.org/)
  * ビルドツール。
  * このプロジェクトでは、JavaScript/CSSファイルを後述する`Babel`を利用して変換してまとめて、ブラウザから実行できるファイルを生成するために利用する。
  * 設定ファイルは[webpack.config.js](../../webpack.config.js)
* [Karma](https://karma-runner.github.io/)
  * テストランナー。ユニットテストの実行に利用する。
* [Mocha](https://mochajs.org/)
  * JavaScript向けのテストフレームワーク。
* [Sinon](http://sinonjs.org/)
  * テスト用のモックライブラリ。
* [Power Assert](https://github.com/power-assert-js/power-assert)
  * Assertionライブラリ。ユニットテストの時のassert処理を簡単かつエラー時に分かりやりやすくできる。
* [ESLint](https://eslint.org/)
  * JavaScript用のLint。オプション(--fix)でコードの修正もしてくれる。
  * 設定ファイルは[.eslintrc](../../.eslintrc)
  * [eslint-config-airbnb](https://github.com/airbnb/javascript]を利用して[airbnb](https://github.com/airbnb/javascript)のJavaScriptコーディングルールを指定している。
  * 後述するVueをフレームワークとして利用するので[eslint-plugin-vue](https://github.com/vuejs/eslint-plugin-vue)も導入済み
  * ACCESSでは大規模なJavaScript開発の場合、加えて[FlowType](https://flow.org/)、[SCSS](https://sass-lang.com/)か[PostCSS](https://github.com/postcss/postcss)、[stylelint](https://github.com/stylelint/stylelint)等を合わせて利用することが多いが、今回のコードでは研修の内容を削減するためにそれらは利用していない。
* [Babel](https://babeljs.io/)
  * JavaScriptのトランスコンパイラ。新しいJavaScriptのコードを対応してないブラウザでも動作するように変換する。
* [jsdom](https://github.com/jsdom/jsdom)
  * DOMのJavaScript実装。
  * このプロジェクトでは、Node上でユニットテストを実行するときに、DOMに依存したコードを動作させるために利用する。

### 実環境でも利用されるライブラリ

* [Bootstrap](https://getbootstrap.com/)
  * UIフレームワーク。
  * このプロジェクトでは、スタイル設定のためCSSのみを利用する。
* [Font Awesome](https://fontawesome.com/)
  * アイコン。
  * このプロジェクトではフリーのアイコンを利用する。
* [Vue](https://vuejs.org/)
  * Reactに似ているが少し簡易な仮装DOMを利用したフレームワーク。
  * ACCESSだと[React](https://reactjs.org/)を利用する案件の方が多いが、このプロジェクトでは研修用なのでとっつきやすいVueを利用する。
* [Axios](https://github.com/axios/axios)
  * PromiseベースのHTTPライブラリ。
* [Lodash](https://lodash.com/)
  * コレクション操作ライブラリ。
  * VueやReactはImmutabilityを重視した[immer](https://github.com/mweststrate/immer)や[ramda](https://github.com/ramda/ramda)や[Immutable.js](https://facebook.github.io/immutable-js/)と相性がいいが、このプロジェクトでは研修向けにとっつきやすいLodashを利用する。


## Vueの概要(TODO)

下記のような部分を簡単に説明(TODO: 座学で時間をもらって行う？)

- mounted
- store
- computed
- data
- v-for
- v-bindとeventの意味と省略形
- {{}}

## フロントエンド関係のファイルの場所(TODO)

<pre>
|-- js_test/  Webfrontendのテストコード
|   |-- components/    componentsのテストコード(TODO)
|   |-- TestHelper.js  テストコードの補助をする
|-- web/
|   |-- static/   静的なファイルの置き場所
|       |-- css/             CSSファイル
|       |-- pages/           ページに相当するVueコンポーネント
|           |-- BookCreationPage.vue      サンプルページである"本の登録ページ"
|           |-- BookListPage.vue          サンプルページである"本の一覧ページ"
|           |-- BookDetailPage.vue        サンプルページである"本の詳細ページ"
|           |-- LoginPage.vue             "Userログインページ"。実装済み。
|           |-- QuestionCreationPage.vue  "質問投稿ページ"(★実装対象)
|           |-- QuestionListPage.vue      "質問一覧ページ"(★実装対象)
|           |-- QuestionDetailPage.vue    "質問詳細ページ"(★実装対象)
|           |-- UserDetailPage.vue        "ユーザ詳細ページ"(★実装対象)
|       |-- components/      ページより小さいレベルのVueコンポーネント。複数のページから利用する可能性がある。
|           |-- Answer.vue    "ユーザ詳細ページ"から利用する"回答コンポーネント"(★実装対象)
|           |-- Book.vue      "本の詳細ページ"から利用する"本コンポーネント"(★実装対象)
|           |-- Comment.vue   "回答コンポーネント"と"質問コンポーネント"から利用する"コメントコンポーネント"(★実装対象)
|           |-- Header.vue    ページのヘッダーのコンポーネント
|           |-- Question.vue  "本の詳細ページ"から利用する"質問コンポーネント"(★実装対象)
|       |-- css/             CSS
|           |-- global.css  グローバルに適用するCSS
|       |-- App.vue          Vueの最上位のコンポーネント
|       |-- AppConfig.js     グローバルに利用する設定の情報
|       |-- global_mixin.js  Vueのglobalなmixin処理
|       |-- main.js          JavaScriptのスタートポイント。これがhtmlから呼ばれる。
|       |-- router.js        Vueのrouter
|       |-- store.js         Vueのstore
|-- .babelrc           Babelの設定ファイル
|-- .eslintrc.js       ESLintの設定ファイル
|-- karma.conf.js      Karmaの設定ファイル
|-- webpack.config.js  WebPackの設定ファイル
|-- yarn.lock          Yarnの設定ファイル
|-- package.json       Yarnのパッケージ情報ファイル
</pre>

(★実装対象)と書いたものが今回の研修で主に実装するファイル。現在は空実装になっている。
ただし、見た目・動作を改善するなどの目的で他のファイル(global.css等)も変更して問題ない。

## Webfrontend向けのセットアップを行う(TODO: 座学の時間をもらって一部を進めたい)

* [Webfrontend向けのセットアップ](../development.md)に従い、セットアップを行う。

## Webfrontendの実行

* (Webfrontendのwebpack-dev-serverの実行)[../development]を行う。

## `質問一覧ページ`のコードを見る

[QuestionListPage.vue](../../web/static/pages/QuestionListPage.vue)の内容を理解する。

- `質問一覧ページ`の表示時にmounted()が呼ばれ、その中で`this.$store.dispatch('retrieveQuestions');`を呼び出し、store.jsで実装されたサーバAPIの呼び出し処理が行われ、storeのstate.questionsに取得したデータが保存される。
- computedのquestions()では、storeのstate.questionsをソートしたデータと指定している。
- template内でquestionsとしてcomputedのquestions()を参照しており、computedが変化するとtemplateの描画が行われる。
- templateではv-forによりquestionsをループで処理してtitleとcreatedAtとuserIdを表示している。
- router-linkを利用して、`質問詳細ページ(QuestionDetailPage)`と`ユーザ詳細ページ(UserDetailPage)`へのリンクを作成している。

## Vue.js Devtoolsを試す

* `質問一覧ページ`をブラウザで開いている時に、`Chrome Devtools`を開き`Vue`タブを選択する。
  * Vueのコンポーネントのツリーが表示される。
  * Vueのコンポーネントを選択すると中のデータ(computed等)が表示される。

## ESLintの挙動を確認する

- 1. [QuestionListPage.vue](../../web/static/pages/QuestionListPage.vue)に利用されない変数を追加する。
```js
   computed: {
     questions() {
+      const a; // 利用していない変数を追加する
       return _.sortBy(this.$store.state.questions, 'createdAt').reverse();
     },
   },
```

- 2. `$ yarn run eslint`を実行すると下記のエラーが表示されることを確認する。
```
/Users/yukioka/project/stackoverflow_clone_b/web/static/pages/QuestionListPage.vue
  33:13  error  Parsing error: Unexpected token ;
```

- 3. 修正を戻す。

- 4. [QuestionListPage.vue](../../web/static/pages/QuestionListPage.vue)のコードフォーマットを修正する。
```js
   computed: {
-    questions() {
+    questions (   ) { // よくわからない空白を追加する
       return _.sortBy(this.$store.state.questions, 'createdAt').reverse();
     },
   },
```

- 5. `$ yarn run eslint`を実行するとエラーが表示されずに自動的にフォーマットが修正されていることを確認する。

## `質問詳細ページ(1.質問とコメントの表示)`の実装をする(TODO)


### ユニットテストを実装する(TODO)

特定のテストのみ実行させたい場合。itにonlyをつけることを話す。
