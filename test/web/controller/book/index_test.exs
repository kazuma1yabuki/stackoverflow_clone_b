defmodule StackoverflowCloneB.Controller.Book.IndexTest do
  use StackoverflowCloneB.CommonCase
  alias Dodai.RetrieveDedicatedDataEntityListRequestQuery, as: Query
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Controller.Book.Index
  alias StackoverflowCloneB.Controller.Book.IndexRequestParams
  alias StackoverflowCloneB.TestData.BookData

  @api_prefix "/v1/book"

  test "index/1 " <>
    "should return books" do
    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      assert req.query == %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
        limit: nil,
        skip:  nil,
        query: %{},
        sort:  %{"_id" => 1}
      }

      %Dodai.RetrieveDedicatedDataEntityListSuccess{body: [BookData.dodai()]}
    end)

    res = Req.get(@api_prefix)
    assert res.status               == 200
    assert Poison.decode!(res.body) == [BookData.gear()]
  end

  test "index/1 " <>
    "should build query" do
    params_list = [
      {%IndexRequestParams{title: nil,     author: nil},      %Query{query: %{},                                                   sort: %{"_id" => 1}}},
      {%IndexRequestParams{title: "title", author: nil},      %Query{query: %{"data.title" => "title"},                            sort: %{"_id" => 1}}},
      {%IndexRequestParams{title: nil,     author: "author"}, %Query{query: %{                         "data.author" => "author"}, sort: %{"_id" => 1}}},
      {%IndexRequestParams{title: "title", author: "author"}, %Query{query: %{"data.title" => "title", "data.author" => "author"}, sort: %{"_id" => 1}}},
    ]
    Enum.each(params_list, fn {params, expected} ->
      assert Index.convert_to_dodai_req_query(params) == expected
    end)
  end
end
