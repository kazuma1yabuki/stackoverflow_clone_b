# Server実習3日目

## 内容

* `Question` APIとして下記のAPIを実装する
  * `retrieveQuestionList API` (`GET  /v1/question`)
    * API自体はすでにあるが、request parameterとして`user_id`が指定された場合は、その指定された値をもつquestionのみを返すように拡張する。
* `Answer` APIとして下記のAPIを実装する
  * `retrieveAnswer API`     (`GET  /v1/answer/{id}`)
    * API自体はすでにあるが、request parameterとして`user_id`または`question_id`が指定された場合は、その指定された値をもつanswerのみを返すように拡張する。

## ヒント

* `Dodai.RetrieveDedicatedDataEntityListRequestQuery.t`のstuctの`query`フィールドに対してrequest parameterをもとに検索条件を組み立てる。
* [Book API](../../web/controller/book/index.ex)が参考になる。
