# Server実習1日目

## 内容

* `Question` APIとして下記のAPIを実装する
  * `createQuestion API`       (`POST /v1/question`)
  * `updateQuestion API`       (`POST /v1/question/{id}`)
  * `retrieveQuestionList API` (`GET  /v1/question`)
    * API自体はすでにあるが、request parameterとして`user_id`が指定された場合は、その指定された値をもつquestionのみを返すように拡張する。

## ヒント

* `Dedicated data collection`()である`Question` collectionが予め用意してあるのでこのcollectionに対してdocumentの作成/更新/取得を行なう。
  * `createQuestion API`では下記のようなdocumentを作成することになる。基本的には`data`部分をユーザが指定した値に基づき組み上げてあげることになる。
    ```
    {
      "_id"        => "5abc7c7c3800003800748888"
      "version"    => 0,
      "created_at" => "2018-03-29T05:41:16+00:00",
      "updated_at" => "2018-03-29T05:41:16+00:00",
      "sections"   => [],
      "owner"      => "_root",
      "data"       => {
        "user_id"           => "5abc7c5f3700003700eb5945", # login userの`_id`(この`question`の投稿者の`_id`)
        "title"             => "title",                    # userが指定した値
        "body"              => "body",                     # userが指定した値
        "like_voter_ids"    => [],                         # 最初は必ず空配列
        "dislike_voter_ids" => [],                         # 最初は必ず空配列
        "comments"          => [],                         # 最初は必ず空配列
      },
    }
    ```
* 認証について
  * `createQuestion API`ではログイン済みであること、`updateQuestion API`ではさらにログインUserと更新対象の`Question`の投稿者が同じであることを確認する必要がある。
    * なおユーザについては事前に講師側で作成してある。ログインのために必要なemailとpasswordは別途連絡する
  * 「ログイン済み」とはユーザが事前にログインAPI(`userLogin API`)を叩き、user credential(レスポンスの`session`の`key`の値)をheaderの`authorization`の値として設定してAPIを叩くことを意味する。
    * 例えば、`createQuestion API`の場合は下記のようなcurlコマンドとなる
      ```
      curl -XPOST -H "authorization: <user credential>" -H "Content-type: application/json" -d '{"title":"title","body":"body"}' <url>/v1/question | jq
      ```
  * gear側の処理としてはこのuser credentialが正しいかを確認する。
  * 正しいかどうかは[この API](https://github.com/access-company/Dodai-doc/blob/master/users_api.md#query-information-about-logged-in-user)を用いて確認できる。
    * gearはheaderからuser credentialを抜き出して、このAPIのパラメータとして設定して上記のAPIを叩く。
    * 上記のAPIはuser credentialが正しい場合、そのcredentialをもつユーザの情報を取得できる。ユーザの情報の取得に成功した場合、「ログイン済み」であると判断する。
      * `updateQuestion API`の場合はここから更にこのユーザのIDとquestionの投稿者のID(`Question`の`data.user_id`)が一致しているかを確認する必要がある。
    * user credentialが正しくない場合、「ログイン済み」でないとしてエラー(401)を返す。
  * 上記の「headerの`authorization`の値をもとにユーザ情報を取得する」という処理はすでに講師側で実装しましたので、それを使うことができます。
    * 実装は[`plug`](https://github.com/access-company/solomon/blob/master/lib/web/controller/plug.ex)という機能を用いて[ここ](../../web/plug/fetch_me.ex)で実装されています。
    * この`plug`は`authorization`の値をもとにユーザ情報を取得して、その情報をactionに渡ってくる引数の`conn`の`assigns`の`me`とフィールドに取得したユーザの情報を格納してくれます。
    * この`plug`は下記のように記述することで、同じmodule内で書かれたactionの「実行前」に自動で呼び出されます。
      ```
      defmodule StackoverflowCloneB.Controller.Question.Create do
        use StackoverflowCloneB.Controller.Application

        # plugを使うことを宣言
        plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

        # 下記のcreate actionが実行される前に上記のplugが実行される
        def create(conn) do
          # connのassignsにheaderのauthorizationの値をもとに取得したユーザの情報が入っている
          json(conn2, 201, %{})
        end
      end
      ```
      * 上記のcreate actionの引数connは下記の様になっており、`assings`の`me`というフィールドにユーザの情報が入っていることが分かる。
      ```
      %SolomonLib.Conn{
        context: %SolomonLib.Context{...},
        request: %SolomonLib.Request{...},
        :
        assigns: %{
          me: %{
            "_id"            => "5ad7fb9e38000038001cb5bf",
            "email"          => "masaki.takahashi11@access-company.com",
            "createdAt"      => "2018-04-19T02:14:54+00:00",
            "updatedAt"      => "2018-04-19T02:14:54+00:00",
            "version"        => 0,
            "data"           => %{},
            "readonly"       => %{},
            "role"           => %{},
            "sectionAliases" => [],
            "sections"       => [],
            "session"        => %{
              "expiresAt"     => "2018-04-20T02:18:17+00:00",
              "key"           => "Cx6mX5RHiCIVmEpa51tB",
              "passwordSetAt" => "2018-04-19T02:14:54+00:00"
            },
          }
        },
      }
      ```
  * この`plug`はcredentialが正しくない場合、401エラーを返してくれる。そのため、`createQuestion API`の実装をする際には`plug`の使うことを宣言するだけでログインユーザの検証は完了である。
  * 一方`updateQuestion API`の実装では`conn`の`assigns`の`me`の`_id_`と更新対象のquestionの`data.user_id`の値が一致しているかの確認が必要である。
* request bodyのvalidationについて
  * `createQuestion API`や`updateQuestion API`はDodaiへリクエストする前にrequest bodyをvalidationする必要がある。(例えば、`title`は必須で1文字以上100文字以内など)
  * これを実現するには[`Croma.Struct`](https://github.com/skirino/croma/blob/master/lib/croma/struct.ex)を使うと便利である。(必須ではないのやりやすい方法でもよいです。)
    * `Croma.Struct`を利用したvalidationは下記のstepとなる
      1. `Croma.Struct`を利用してstructを宣言的に定義する
      1. 自動生成される`new/1`関数を用いてreqest bodyをvalidationする。
         * 宣言したstructを満たすmapであれば、`{:ok, XXX}`が返り、そうでなければ`{:error, XXX}`が返る。
      1. 返り値により分岐を行い、`{:ok, XXX}`であれば次の処理、`{:error, XXX}`であれば、クライアントには404エラーを返し処理を終了する。
    * 具体的な`Croma.Struct`の使用例は[ここ](./croma.md)を参照
* `retrieveQuestionList API`でのrequest parameterについて
  * `user_id`が指定された場合は、`data.user_id`として指定された値をもつ`Question`のみをレスポンスとして返す必要がある。
  * そのためには、Dodaiに対してrequestする際の`query`として「`data.user_id`が指定された値をもつこと」という条件を与える`query`を含めなければならない。
