# Server実習4日目

## 内容

* `Comment` APIとして下記のAPIを実装する
  * `createComment API` (`POST /v1/question/{:question_id}/comment`, `POST /v1/answer/{:answer_id}/comment`)
  * `updateComment API` (`POST /v1/question/{:question_id}/comment/{id}`, `POST /v1/answer/{:answer_id}/comment/{id}`)

## ヒント

* `Comment`の作成は対象の`Question`/`Answer`のdocumentの`data.comments`に要素を追加することを意味する。
  * `Question`/`Answer`の対応するdocumentはpath中の`{:question_id}`/`{:answer_id}`の値を元に取得する。
  * `id`はユニークな値を生成して上げる必要があるが、これは十分に長いランダムな文字列を生成してあげればよい。
  * ランダムな文字列は[random_string](https://github.com/sylph01/random_string)で20文字程度生成すればよい。
  * 下記のようなQuestionのdocumentに対してcommentを追加すると、
    ```
    {
      "_id"        => "5abc7c7c3800003800748888"
      "version"    => 0,
      "created_at" => "2018-03-29T05:41:16+00:00",
      "updated_at" => "2018-03-29T05:41:16+00:00",
      "sections"   => [],
      "owner"      => "_root",
      "data"       => {
        "user_id"           => "5abc7c5f3700003700eb5945",
        "title"             => "title",
        "body"              => "body",
        "like_voter_ids"    => [],
        "dislike_voter_ids" => [],
        "comments"          => [],
      },
    }
    ```
    下記のように`comments`に要素が追加されることになる。
    ```
    {
      "_id"        => "5abc7c7c3800003800748888"
      "version"    => 0,
      "created_at" => "2018-03-29T05:41:16+00:00",
      "updated_at" => "2018-03-29T05:41:16+00:00",
      "sections"   => [],
      "owner"      => "_root",
      "data"       => {
        "user_id"           => "5abc7c5f3700003700eb5945",
        "title"             => "title",
        "body"              => "body",
        "like_voter_ids"    => [],
        "dislike_voter_ids" => [],
        "comments"          => [
          {
            "id"         => "N6MeNogNEs34JkgZPg9l",      # 上記の方法でランダムな文字列を生成
            "user_id"    => "5abc7c5f3700003700eb5945",  # login userの`_id`
            "body"       => "body1"                      # userが指定した値
            "created_at" => "2018-04-04T04:53:57+00:00", # comment作成時の時刻
          }
        ],
      },
    }
    ```
* `Comment`の更新は対象の`Question`/`Answer`のdocumentの`data.comments`に要素の中で`id`がpathで指定された`{id}`と一致する`comment`を更新する。
