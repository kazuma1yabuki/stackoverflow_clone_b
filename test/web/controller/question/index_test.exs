defmodule StackoverflowCloneB.Controller.Question.IndexTest do
  use StackoverflowCloneB.CommonCase
  alias Dodai.RetrieveDedicatedDataEntityListRequestQuery, as: Query
  alias StackoverflowCloneB.TestData.QuestionData
  alias StackoverflowCloneB.Controller.Question.{Index, IndexRequestParams}

  @api_prefix "/v1/question"

  test "index/1 " <>
    "should return questions" do
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
  "should build query" do
    params_list = [
      {%IndexRequestParams{user_id: nil,       title: nil,     body: nil   }, %Query{query: %{                                                                           }, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: nil,       title: "title", body: nil   }, %Query{query: %{                             "data.title" => "title"                       }, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: nil,       title: nil,     body: "body"}, %Query{query: %{                                                      "data.body" => "body"}, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: "user_id", title: nil,     body: nil   }, %Query{query: %{"data.user_id" => "user_id"                                                }, sort: %{"_id" => 1}}},
      {%IndexRequestParams{user_id: "user_id", title: "title", body: "body"}, %Query{query: %{"data.user_id" => "user_id", "data.title" => "title", "data.body" => "body"}, sort: %{"_id" => 1}}},
    ]
    Enum.each(params_list, fn {params, expected} ->
      assert Index.convert_to_dodai_req_query(params) == expected
    end)
  end
end
