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
        limit: 10,
        skip:  0,
        query: %{},
        sort:  %{"createdAt" => 1}
      }

      %Dodai.RetrieveDedicatedDataEntityListSuccess{body: [QuestionData.dodai()]}
    end)

    res = Req.get(@api_prefix)
    assert res.status               == 200
    assert Poison.decode!(res.body) == [QuestionData.gear()]
  end

  test "index/1 " <>
    "should return questions by user_id query" do
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      assert req.query == %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
        limit: 10,
        skip:  0,
        query: %{"data.user_id" => "user_id"},
        sort:  %{"createdAt" => 1}
      }

      %Dodai.RetrieveDedicatedDataEntityListSuccess{body: [QuestionData.dodai()]}
    end)

    res = Req.get(@api_prefix <> "?" <> build_query_string(%{"user_id" => "user_id"}))
    assert res.status               == 200
    assert Poison.decode!(res.body) == [QuestionData.gear()]
  end

  test "index/1 " <>
  "should build question query" do
    params_list = [
      {%IndexRequestParams{user_id: nil,       title: nil,     body: nil   }, %Query{limit: 10, skip: 0, query: %{                                                                           }, sort: %{"createdAt" => 1}}},
      {%IndexRequestParams{user_id: nil,       title: "title", body: nil   }, %Query{limit: 10, skip: 0, query: %{                             "data.title" => "title"                       }, sort: %{"createdAt" => 1}}},
      {%IndexRequestParams{user_id: nil,       title: nil,     body: "body"}, %Query{limit: 10, skip: 0, query: %{                                                      "data.body" => "body"}, sort: %{"createdAt" => 1}}},
      {%IndexRequestParams{user_id: "user_id", title: nil,     body: nil   }, %Query{limit: 10, skip: 0, query: %{"data.user_id" => "user_id"                                                }, sort: %{"createdAt" => 1}}},
      {%IndexRequestParams{user_id: "user_id", title: "title", body: "body"}, %Query{limit: 10, skip: 0, query: %{"data.user_id" => "user_id", "data.title" => "title", "data.body" => "body"}, sort: %{"createdAt" => 1}}},
    ]
    Enum.each(params_list, fn {params, expected} ->
      assert Index.convert_to_dodai_req_query(params, "-1") == expected
      assert Index.convert_to_dodai_req_query(params, "0") == expected
      assert Index.convert_to_dodai_req_query(params, "1") == expected
    end)
  end
end
