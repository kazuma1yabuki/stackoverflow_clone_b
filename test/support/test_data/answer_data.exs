defmodule StackoverflowCloneB.TestData.AnswerData do
    @dodai %{
        "_id" => "answer_id",
        "title" => "title",
        "body" => "body",
        "user_id" => "user_id",
        "created_at" => "2018-02-27T06:34:52+00:00",
        "comments" => [
          %{
            "_id" => "comment_id1",
            "user_id" => "589d196d22000036137e473b",
            "created_at" => "2018-02-27T06:35:26+00:00",
            "body" => "body1"
          },
          %{
            "_id" => "comment_id2",
            "user_id" => "589d196d22000036137e473b",
            "created_at" => "2018-02-27T06:36:26+00:00",
            "body" => "body2"
          }
        ],
        "like_voter_ids" => [
          "589d196d22000036137e473b"
        ],
        "dislike_voter_ids" => [5976b4b037000037006d69c4]
    }
    @gear Map.merge(@dodai["data"], %{"id" => @dodai["_id"], "created_at" => @dodai["createdAt"]})
  
    def dodai(), do: @dodai
    def gear(),  do: @gear
  end
  