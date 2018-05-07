# Webfrontend開発ハンズオン

## 内容

* 今後作成するものを理解する。
* ツールの概要・使い方を理解する。
* `質問詳細ページ(1.質問の表示)`を実装する。
  * 質問詳細ページを全て実装するのではなく、質問の表示(コメントを含まない。タイトルと本文の表示)のみを対応する。

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
  * 設定ファイルは[.eslintrc](../../.eslintrc.js)
  * [eslint-config-airbnb](https://github.com/airbnb/javascript)を利用して[airbnb](https://github.com/airbnb/javascript)のJavaScriptコーディングルールを指定している。
  * 後述するVueをフレームワークとして利用するので[eslint-plugin-vue](https://github.com/vuejs/eslint-plugin-vue)も導入済み
  * ACCESSでは大規模なJavaScript開発の場合、加えて[FlowType](https://flow.org/)、[SCSS](https://sass-lang.com/)か[PostCSS](https://github.com/postcss/postcss)、[stylelint](https://github.com/stylelint/stylelint)等を合わせて利用することが多いが、今回のコードでは研修の内容を削減するためにそれらは利用していない。
* [Babel](https://babeljs.io/)
  * JavaScriptのトランスコンパイラ。新しいJavaScriptのコードを対応してないブラウザでも動作するように変換する。
* [jsdom](https://github.com/jsdom/jsdom)
  * DOMのJavaScript実装。
  * このプロジェクトでは、Node上でユニットテストを実行するときに、DOMに依存したコードを動作させるために利用する。
* [babel-plugin-rewire](https://github.com/speedskater/babel-plugin-rewire)
  * テスト対象の特定変数をモックする[rewire](https://github.com/jhnns/rewire)をbabelで利用しやすくする。
  * テスト対象のファイルが読み込むライブラリmockするために利用する。

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

## フロントエンド関係のファイルの場所

<pre>
|-- js_test/  Webfrontendのテストコード
|   |-- components/          componentsのテストコード(★一部実装対象)
|   |-- pages/               pagesのテストコード(★一部実装対象)
|   |-- TestHelper.js        テストコードの補助をする処理
|   |-- HtttpClient.spec.js  HtttpClient.jsのテスト
|   |-- store.spec.js        store.jsのテスト
|-- web/
|   |-- static/   静的なファイルの置き場所
|       |-- css/             CSSファイル
|       |-- pages/           ページに相当するVueコンポーネント
|           |-- BookCreationPage.vue      サンプルページである"本の登録ページ"
|           |-- BookListPage.vue          サンプルページである"本の一覧ページ"
|           |-- BookDetailPage.vue        サンプルページである"本の詳細ページ"
|           |-- LoginPage.vue             "Userログインページ"。実装済み。
|           |-- QuestionCreationPage.vue  "質問投稿ページ"(★実装対象)
|           |-- QuestionListPage.vue      "質問一覧ページ"。実装済み。
|           |-- QuestionDetailPage.vue    "質問詳細ページ"(★実装対象)
|           |-- UserDetailPage.vue        "ユーザ詳細ページ"実装済み。実装済み。
|       |-- components/      ページより小さいレベルのVueコンポーネント。複数のページから利用する可能性がある。
|           |-- Answer.vue    "質問詳細ページ"から利用する"回答コンポーネント"(★実装対象)
|           |-- Book.vue      "本の詳細ページ"から利用する"本コンポーネント"
|           |-- Comment.vue   "回答コンポーネント"と"質問コンポーネント"から利用する"コメントコンポーネント"(★実装対象)
|           |-- Header.vue    ページのヘッダーのコンポーネント
|           |-- Question.vue  "質問詳細ページ"から利用する"質問コンポーネント"(★実装対象)
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

## Webfrontend向けのセットアップを行う

* [Webfrontend向けのセットアップ](../development.md)に従い、セットアップを行う。

## Webfrontendの実行

* [Webfrontendのwebpack-dev-serverの実行](../development.md#webfrontendのwebpack-dev-serverの実行)を行う。
  * この状態でJavaScriptのコードを修正するとブラウザが自動的にブラウザでリロードされる。

## Vueのコードの例として`質問一覧ページ`のコードを見る

[QuestionListPage.vue](../../web/static/pages/QuestionListPage.vue)で簡単に説明する。

* このファイルは、`<template>`と`<script>`と`<style scoped>`の3つの部分に分かれている。
* `質問一覧ページ`の表示時に`mounted()`が呼ばれ、その中で`methods`で定義された`retrieveQuestions()`を呼び出している。
  * `mounted`はVueでそのコンポーネントが表示時にマウントされるときに呼ばれる決められた関数で、
    * コンポーネントのライフサイクルに関しては[Understanding Vue.js Lifecycle Hooks](https://alligator.io/vuejs/component-lifecycle/)の図が分かりやすい。
* `retrieveQuestions()`の中で、`this.$store.dispatch('retrieveQuestions');`を呼び出している。`retrieveQuestions` actionは、[store.js](../../web/static/store.js)で定義されており、サーバにqestuionsをリクエストして取得したquestionを`this.$store.state.questions`に保存する。
* `computed`の`questions()`では、`this.$store.state.questions`をソートしたデータと定義している。
  * この`computed`は、中で利用している情報が変更されたときに、それを利用している表示部分を自動的に再表示してくれる。今回で言えば、`<template>`内で`questions`を利用すると、`this.$store.state.questions`が更新されたときに自動的に`<template>`が再描画される。
* templateでは`v-for`ディレクティブによりquestionsをループで処理してtitleとcreatedAtとuserIdを表示している。
  * Vueでは`v-for`ディレクティブを利用してテンプレート内で特定のリストに対する繰り返しを実現できる。参照: [List Rendering](https://vuejs.org/v2/guide/list.html)。
* `router-link`を利用して、`質問詳細ページ(QuestionDetailPage)`と`ユーザ詳細ページ(UserDetailPage)`へのリンクを作成している。

## Vue.js Devtoolsを試す

* `質問一覧ページ`をブラウザで開いている時に、`Chrome Devtools`を開き`Vue`タブを選択する。
  * Vueのコンポーネントのツリーが表示される。
  * Vueのコンポーネントを選択すると中のデータ(computed等)が表示される。

## ESLintの挙動を確認する

- 1. [QuestionListPage.vue](../../web/static/pages/QuestionListPage.vue)に利用されない変数を追加する。
```js
   computed: {
     questions() {
+      const a = 10; // 利用していない変数を追加する
       return _.sortBy(this.$store.state.questions, 'createdAt').reverse();
     },
   },
```

- 2. `$ yarn run eslint`を実行すると下記のエラーが表示されることを確認する。
```
[path]/web/static/pages/QuestionListPage.vue
  33:13  error  'a' is assigned a value but never used  no-unused-vars
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

## `質問詳細ページ(1.質問とコメントの表示)`の実装をする

* [質問詳細ページ(QuestionDetailPage.vue)](../../web/static/pages/QuestionDetailPage.vue)は実装は、サンプルページである[本の詳細ページ(BookDetailPage.vue)](../../web/static/pages/BookDetailPage.vue)を参考にする。
  * ブラウザでパス`#/book`から任意の本をクリックしてページ移動して表示できる。
* [質問コンポーネント(Question.vue)](../../web/static/components/Question.vue)の実装は、[本コンポーネント(BookDetailPage.vue)](../../web/static/components/Book.vue)を参考にする。

### 機能の実装

[QuestionDetailPage.vue](../../web/static/pages/QuestionDetailPage.vue)と[Question.vue](../../web/static/components/Question.vue)の空実装を実装する。

#### 1. questionの取得の実装

* 表示時にマウントされるときに呼ばれる`mounted`で、questionをサーバから取得するリクエストを呼べばいい。
* [BookDetailPage.vue](../../web/static/pages/BookDetailPage.vue)のようにmethodsとして`retrieveQuestion()`を定義して呼び出す。。
* `retrieveQuestion()`の実装
  * questionの取得は[store.js](../../web/static/store.js)で`retrieveQuestion` actionとして定義されているので、[BookDetailPage.vue](../../web/static/pages/BookDetailPage.vue)のように呼び出す。
    * この`retrieveQuestion` actionは取得したquestionを`this.$store.state.question`に保存する。
  * この時点で、Chrome DevToolsのネットワークパネルと見ると、`v1/question/:question_id`に対してリクエストが送信してquestionが返されていることが確認できる。

この時点でのコードは下記になる。

```js
<template>
  <div>
    !not_implemented!
  </div>
</template>

<script>
import Question from '@/components/Question';
import Answer from '@/components/Answer';
import Comment from '@/components/Comment';

export default {
  name: 'QuestionDetailPage',
  components: {
    Question,
    Answer,
    Comment,
  },
  data() {
    return {
    };
  },
  computed: {
  },
  mounted() {
    this.retrieveQuestion();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
  },
};
</script>

<style scoped>
</style>
```

#### 2. questionの仮表示

* 取得したquestionは`this.$store.state.question`に保存されているので、[BookDetailPage.vue](../../web/static/pages/BookDetailPage.vue)と同様に、それを取得する`question()`を`computed`に作る。
* `<template>`内で、試しに`computed`内に定義した`question()`を呼び出してみる。`{{question}}`と書くと、取得したquestionの内容が表示される。この`{{}}`の表記は中のJavaScriptを実行して結果を表示する。
* `<template>`の描画はquestionのデータを取得する前に1度行われ、取得後に`computed`の動作により再度行われる。questionの取得が終わる前に表示はしなくないので、[BookDetailPage.vue](../../web/static/pages/BookDetailPage.vue)のように`hasValidQuestion()`を作って、データが取得されていないときは[`v-if`ディレクティブ](https://vuejs.org/v2/guide/conditional.html)を使って表示しないようにする。
  * `v-if`ディレクティブを使うと、指定した評価式がfalseになったときのみその要素を表示することができる。
* その内で`{{question.title}}`や`{{question.body}}`のように書くとquestionのタイトルや内容を表示できる

この時点でのコードは下記になる。

```js
<template>
  <div>
    <div v-if="hasValidQuestion">
      {{question.title}}<br>
      {{question.body}}<br>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';
import Question from '@/components/Question';
import Answer from '@/components/Answer';
import Comment from '@/components/Comment';

export default {
  name: 'QuestionDetailPage',
  components: {
    Question,
    Answer,
    Comment,
  },
  data() {
    return {
    };
  },
  computed: {
    hasValidQuestion() {
      return !_.isEmpty(this.question) && this.question.id === this.$route.params.id;;
    },
    question() {
      return this.$store.state.question;
    },
  },
  mounted() {
    this.retrieveQuestion();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
  },
};
</script>

<style scoped>
</style>
```

#### 3. コンポーネントの分離

* このページは最終的に多くの表示をするので、質問とそのコメントの部分を別にコンポーネントに分ける。
  * 既に質問の部分のコンポーネントは[Question.vue](../../web/static/components/Question.vue)に空実装が存在する。
* Vueで別のコンポーネントを呼ぶ場合、exportしている部分の`components`に呼び出したいコンポーネント(今回は`Question`)を記述して、`<template>`内でコンポーネント名のPascalCaseをHyphen-Caseにしたもの(今回は`<question>`)を記述すればいい。
* 子のコンポーネントにデータを渡したい場合、[BookDetailPage.vue](../../web/static/pages/BookDetailPage.vue)の`:book="book"`のように`:question="question"`と書くと子のコンポーネントのpropsとして渡せるので、`<question :question="question"/>`と書けばいい。
  * この`:question`は`v-bind:question`の[省略形](https://vuejs.org/v2/guide/syntax.html#v-bind-Shorthand)であり、[v-bind](https://vuejs.org/v2/api/#v-bind)は引数の文字列ではなく式として処理するためのディレクティブである。つまり、ここでは、"question"という文字列を渡すのではなく、questionオブジェクトを渡すという意味になる。
* `<template>`以下の`<div>`の中に`{{question.title}}`や`{{question.body}}`のように書くとquestionのタイトルや内容を表示できる。
  * 後述のユニットテストやスタイルの設定のために`<div class="page-title">{{ question.title }}</div>`のようにクラス属性を付けた要素で包んでおく。
  * 注意: `<template>`直下に複数の要素はVueにより禁止されているので、`<template>`の直下の`<div>`の下に複数の要素を作る必要がある。

この時点でのコードは下記になる。

QuestionDetailPage.vue
```js
<template>
  <div>
    <div v-if="hasValidQuestion">
      <question :question="question"/>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';
import Question from '@/components/Question';
import Answer from '@/components/Answer';
import Comment from '@/components/Comment';

export default {
  name: 'QuestionDetailPage',
  components: {
    Question,
    Answer,
    Comment,
  },
  data() {
    return {
    };
  },
  computed: {
    hasValidQuestion() {
      return !_.isEmpty(this.question) && this.question.id === this.$route.params.id;;
    },
    question() {
      return this.$store.state.question;
    },
  },
  mounted() {
    this.retrieveQuestion();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
  },
};
</script>

<style scoped>
</style>
```

Question.vue
```js
<template>
  <div>
    <div class="page-title">{{ question.title }}</div>
    <div class="body">{{ question.body }}</div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Question',
  components: {
    Comment,
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style scoped>
</style>
```

### ユニットテストの実装

#### [Question.spec.js](../../js_test/components/Question.spec.js)の空実装の実装

[Book.spec.js](../../js_test/components/Book.spec.js)を参考にテストを書く。

* テストに利用するquestionのデータを作る。
* mochaの`beforeEach()`でstoreを生成する。
* mochaの`it()`でテストケースを書く。
  * vue-test-utilsの[shallow()](https://vue-test-utils.vuejs.org/en/api/shallow.html)でコンポーネントをrenderさせる。
  * `wrapper.find()`を利用して、要素を取り出して、結果を`assert()`で比較する。

この時点でのコードは下記になる。
```js
import assert from 'power-assert';
import Vuex from 'vuex';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import Question from '@/components/Question';
import router from '@/router';

describe('Question', function () {
  let store;
  const question = {
    id: '5aef02ae36000036000cd039',
    created_at: '2018-05-06T13:27:10+00:00',
    user_id: '5aa2100737000037001811c3',
    title: 'titleX',
    like_voter_ids: [],
    dislike_voter_ids: [],
    comments: [
      {
        user_id: '5aa2100737000037001811c3',
        id: '0GhVJIvT3TUqastruFr9',
        created_at: '2018-05-06T14:00:23+00:00',
        body: 'bodyX',
      },
    ],
    body: 'bodyX',
  };

  beforeEach(function () {
    store = new Vuex.Store({
      state: {
      },
      actions: {
      },
    });
  });

  it('renders answer body and comment components', function () {
    const wrapper = shallow(Question, {
      store,
      router,
      propsData: {
        question,
      },
    });
    assert(wrapper.find('.page-title').text().includes(question.title));
    assert(wrapper.find('.body').text().includes(question.body));
  });
});
```
