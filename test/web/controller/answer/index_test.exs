defmodule StackoverflowCloneB.Controller.Answer.IndexTest do
  use StackoverflowCloneB.CommonCase
  alias Dodai.RetrieveDedicatedDataEntityListRequestQuery, as: Query
  alias StackoverflowCloneB.TestData.QuestionData
  alias StackoverflowCloneB.Controller.Answer.{Index, IndexRequestParams}

  @api_prefix "/v1/answer"

  test "indedx/1 " <>
    "should return answer" do
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      assert req.query == %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
        limit: nil,
        skip:  nil,
        query: %{},
        sort:  %{"_id" => 1}
      }

      %Dodai.RetrieveDedicatedDataEntityListSuccess{body: [QuestionData.dodai()]}
    end)

    res = Req.get(@api_prefix)
    assert res.status               == 200
    assert Poison.decode!(res.body) == [QuestionData.gear()]
  end

  test "index/1 " <>
  "should build answer query" do
    params_list = [
      {%IndexRequestParams{user_id: nil,       question_id: nil,           body: nil   }, %Query{query: %{                                                                                       }, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: nil,       question_id: "question_id", body: nil   }, %Query{query: %{                             "data.question_id" => "question_id"                       }, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: nil,       question_id: nil,           body: "body"}, %Query{query: %{                                                                  "data.body" => "body"}, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: "user_id", question_id: nil,           body: nil   }, %Query{query: %{"data.user_id" => "user_id"                                                            }, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: "user_id", question_id: "question_id", body: "body"}, %Query{query: %{"data.user_id" => "user_id", "data.question_id" => "question_id", "data.body" => "body"}, sort: %{"_id" => 1}}},
    ]
    Enum.each(params_list, fn {params, expected} ->
      assert Index.convert_to_dodai_req_query(params) == expected
    end)
  end
end
