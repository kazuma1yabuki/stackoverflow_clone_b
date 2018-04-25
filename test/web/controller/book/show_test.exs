defmodule StackoverflowCloneB.Controller.Book.ShowTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.BookData

  @api_prefix "/v1/book/book_id"

  test "show/1 " <>
    "it returns book" do
    :meck.expect(G2gClient, :send, fn(_, _, _) ->
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: BookData.dodai()}
    end)

    res = Req.get(@api_prefix)
    assert res.status               == 200
    assert Poison.decode!(res.body) == BookData.gear()
  end

  test "show/1 " <>
    "when specified book is not found " <>
    "it returns ResourceNotFoundError" do
    :meck.expect(G2gClient, :send, fn(_, _, _) ->
      %Dodai.ResourceNotFound{}
    end)

    res = Req.get(@api_prefix)
    assert res.status               == 404
    assert Poison.decode!(res.body) == %{
      "code"        => "404-04",
      "description" => "The resource does not exist in the database.",
      "error"       => "ResourceNotFound",
    }
  end
end
