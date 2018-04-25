# Gear開発ハンズオン

## 内容

* [Setupドキュメント](../development.md)に従い、ベースとなるgearのSetupを行なう。
* 開発するGearの設計について理解する。
* `retrieveQuestion API`を実装する。

## gearのSetup

* [Setupドキュメント](../development.md)に従い、ベースとなるgearのSetupを行なう。
  * 今回利用する`app_id`は`XXXX(TODO: appを作成する)`であり、`group_id`は[ここ](https://docs.google.com/spreadsheets/d/1PSWQ7XDODvCqVvZ2P4jK1bj6oUpN1VlB1dcUCgVyoUY/edit#gid=927490106)を参照
  * `root key`, `app key`は[ここ](https://docs.google.com/spreadsheets/d/1PSWQ7XDODvCqVvZ2P4jK1bj6oUpN1VlB1dcUCgVyoUY/edit#gid=0)参照してac consoleにログインして確認

## Gearの設計について

* 設計は[ここ](../design/collection.md)を参照。

## `retrieveQuestion API`の実装

* `retrieveQuestion API` (`GET /v1/question/:id`)の実装を下記の流れで行なう。
1. router, controllerとactionを定義する。
1. actionの中身を実装する。
1. テストを実装する。

### 1. router, controllerとactionを定義する。

まずstatusが`200`でbodyが`{}`のresponseが返るように実装する。
* `web/router.ex`でのroutingの定義。
* `web/controller/question/show.ex`ファイルを新規作成し、routingと対応するactionの関数を実装する。
  * actionの中身は[`json`](https://ac-console.solomondev.access-company.com/exdoc/solomon/SolomonLib.Controller.Json.html#json/3)を使って、statusが`200`でbodyが`{}`のresponseが返るように書く。

`curl -XGET http://{URL}:8080/v1/question/id`でresponseを確認。

### 2. actionの中身を実装する

下記を実装する。

1. `Conn`の`path_matches`から取得対象の`Question`の`id`を抜き出す。
   * `Conn.t`のtypeは[ここ](https://ac-console.solomondev.access-company.com/exdoc/solomon/SolomonLib.Conn.html#t:t/0)を参照
   * action内で`IO.inspect conn`などどするとconnの下記のように具体的な中身が確認できます。
     ```
     %SolomonLib.Conn{
       assigns:     %{},
       before_send: [],
       context:     %SolomonLib.Context{...},
       request:     %SolomonLib.Request{
         body:         "",
         raw_body:     "",
         cookies:      %{},
         headers:      %{"accept" => "*/*", "host" => "stackoverflow-clone.localhost:8080", "user-agent" => "curl/7.54.0"},
         method:       :get,
         path_info:    ["v1", "question", "5abc7c7c3800003800748888"],
         path_matches: %{id: "5abc7c7c3800003800748888"}, # <= ここから`/question/:id`のpath中で`:id`として指定した値が取得できる。
         query_params: %{},
         sender:       {:web, "127.0.0.1"}
       },
       resp_body:    "",
       resp_cookies: %{},
       resp_headers: %{},
       status:       nil
     }
     ```
1. `Sazabi.G2gClient`を使いDodaiの`Question` collectionから対象のidをもつdocumentを取得する。
   * [このSazabiの関数](https://github.com/access-company/sazabi/blob/master/lib/g2g_client.ex#L210)を用いて[このDodaiのAPI](https://github.com/access-company/Dodai-doc/blob/master/datastore_api.md#retrieve-an-existing-document)を叩く。
   * `Sazabi.G2gClient.send/3`の第三引数として`Dodai.RetrieveDedicatedDataEntityRequest.t`が必要になるが、これは[ここ](https://github.com/access-company/DodaiClientElixir/blob/master/lib/request.ex#L526)で定義され、`Dodai.RetrieveDedicatedDataEntityRequest.new/4`を使うことで生成できる。
     * この`Dodai.RetrieveDedicatedDataEntityRequest.new/4`の第三引数として事前に取得した`Question`の`_id`を渡す。
     * `group_id`の取得などは[ここ](./server_qaa.md#app_idやroot_keyはどのように取得すればいいですか)を参照。
     * `data_collection_name`は[ここ](../design/collection.md#設計)に記載の通り`Question`。
     * `credential`はroot_keyを使う。root_keyの取得は[ここ](./server_qaa.md#app_idやroot_keyはどのように取得すればいいですか)を参照。
1. 取得したdocumentから必要な情報を抜き出してresponse bodyを作成する。
   * `Sazabi.G2gClient.send/3`の返り値は[ここ](https://github.com/access-company/DodaiClientElixir/blob/master/lib/response.ex#L690)で定義される。
   * 取得成功時は`Dodai.RetrieveDedicatedDataEntitySuccess.t`が返るので、[ここ](https://github.com/access-company/DodaiClientElixir/blob/master/lib/response_success.ex#L347)に定義される通り`body`を取得することで、documentの中身を確認できる。この情報をもとにresponse bodyを生成する。
   * 存在しないidを指定した場合は`Dodai.ResourceNotFound.t`が返るのでこの場合は、404エラーを返す。
     * エラー時のレスポンスの返し方は[ここ](./server_qaa.md#error-responseを簡単に返す方法はないですか)を参照
   * 取得成功時と失敗時の分岐は返り値の型をもとに[case文](https://elixir-lang.org/getting-started/case-cond-and-if.html#case)のパターンマッチで実現できる。

`curl -XGET http://{URL}:8080/v1/question/id`でresponseを確認。(`id`の部分は各々の環境で実在するidを指定する)

### 3. テストを実装する

下記の流れで実装する。
1. `test/web/controller/question/show_test.exs`ファイルを作成し、下記のコードを記載する。
   ```
   defmodule StackoverflowCloneB.Controller.Question.ShowTest do
     use StackoverflowCloneB.CommonCase
    
     test "show/1 " do
       assert true
     end
   end
   ```
※ [`assert`](https://hexdocs.pm/ex_unit/ExUnit.Assertions.html#assert/1)は[ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html)が提供する値が`true`であることを確認する関数であり、期待する値とテストしたい関数の演算結果を比較するために用いる。

下記のコマンドでテストを実行し、成功することを確認する。
```
$ mix test test/web/controller/question/show_test.exs
```
2. `test`の中身を実装する。具体的には、`GET /v1/question/id`のリクエストを行い、その結果が期待値と一致しているかを`assert`で確認するロジックを書く。
   1. `GET /v1/question/id`のリクエストは[このmodule](https://github.com/access-company/solomon/blob/master/lib/test/http_client.ex)で提供される関数を使って実現できる。
      * [`retrieveQuestionList API`のテスト](../../test/web/controller/question/index_test.exs)が参考になる。
   1. dodaiへのrequestをmockする。
      * これは、`GET /v1/question/id`のリクエストを行なうと(sazabi経由で)dodaiに対してrequestされてしまい、dodai上のリソースに応じて処理結果がかわってしまうため、dodai上のデータに依存しない形でテストを記述するためである。
      * [`meck`](https://github.com/eproxus/meck)を利用して`Sazabi.G2gClient.send/3`の中身をmockする。
      * 具体的には`meck.expect/3`を使うことで下記のようにfunctionの動作をmockできる。
        ```
        defmodule Hoge do
          def foo(x) do
            x + 1
          end
        end

        > Hoge.foo(1)
        2

        # Hoge.foo/1の処理を書き換える
        :meck.expect(Hoge, :foo, fn(x) -> x + 2 end)

        > Hoge.foo(1)
        3
        ```
        この仕組を利用して、`Sazabi.G2gClient.send/3`が成功のresponse(`Dodai.RetrieveDedicatedDataEntitySuccess.t`型のresponse)やエラー(`Dodai.ResourceNotFound.t`型のresponse)を返したときに適切にハンドリングして期待している値が返っているかを確認する。
        ※引数の数は正確に記述する必要があります。数が違っているとmockが適用されません。
        ```
        defmodule Hoge do
          # 引数が2つの関数を定義
          def foo(x, y) do
            x + y
          end
        end

        > Hoge.foo(1, 2)
        3

        # `fn`の引数が2つになるように定義
        :meck.expect(Hoge, :foo, fn(x, y) -> x + y + 2 end)

        > Hoge.foo(1, 2)
        5
        ```
