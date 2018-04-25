# Server実習2日目

## 内容

* `Answer` APIとして下記のAPIを実装する
  * `createAnswer API`       (`POST /v1/answer`)
  * `retrieveAnswerList API` (`GET  /v1/answer`)
  * `updateAnswer API`       (`POST /v1/answer/{id}`)
  * `retrieveAnswer API`     (`GET  /v1/answer/{id}`)
    * `user_id`と`question_id`での検索はスキップしてよい。(3日目に実施)

## ヒント

* `Dedicated data collection`()である`Answer` collectionが予め用意してあるのでこのcollectionに対してdocumentの作成/更新/取得を行なう。
  * `createAnswer API`では下記のようなdocumentを作成することになる。基本的には`data`部分をユーザが指定した値に基づき組み上げてあげることになる。
    ```
    {
      "_id"        =>  "5ac458653700003700ec2b3e"
      "version"    =>  0,
      "updated_at" => "2018-04-04T04:45:25+00:00",
      "created_at" => "2018-04-04T04:45:25+00:00",
      "sections"   =>  [],
      "owner"      => "_root",
      "data"       => {
        "user_id"     => "5abc7c5f3700003700eb5945", # login userの`_id`
        "question_id" => "5abc7c7c3800003800748888", # userが指定した値
        "body"        => "body3"                     # userが指定した値
        "comments"    => [],                         # 最初は必ず空配列
      },
    }
    ```
