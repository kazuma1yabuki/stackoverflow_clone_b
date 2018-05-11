defmodule StackoverflowCloneB.TestData.AnswerData do
  @dodai %{
    "_id"       => "id",
    "owner"     => "_root",
    "sections"  => [],
    "version"   => 0,
    "createdAt" => "2018-02-18T01:01:00+00:00",
    "updatedAt" => "2018-02-18T01:01:00+00:00",
    "data"      => %{
      "body"        => "本文",
      "user_id"     => "user_id",
      "question_id" => "question_id",
      "comments"    => [
        %{
          "_id"        => "comment_id1",
          "body"       => "本文1",
          "user_id"    => "5976b4b037000037006d69c0",
          "created_at" => "2018-02-19T01:01:00+00:00"
        },
        %{
          "_id"        => "comment_id2",
          "body"       => "本文2",
          "user_id"    => "5976b4b037000037006d69c1",
          "created_at" => "2018-02-19T01:02:00+00:00"
        }
      ],
    }
  }
  @gear Map.merge(@dodai["data"], %{"id" => @dodai["_id"], "created_at" => @dodai["createdAt"]})

  def dodai(), do: @dodai

  def gear(), do: @gear
end
