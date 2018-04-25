defmodule StackoverflowCloneB.Controller.Book.CreateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.BookData

  @api_prefix "/v1/book"
  @header     %{}
  @body       %{"title" => "title", "author" => "author"}

  test "create/1 " <>
    "should create book" do
    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      assert req.body == %Dodai.CreateDedicatedDataEntityRequestBody{
        _id:  nil,
        data: %{author: "author", title: "title"},
      }
      %Dodai.CreateDedicatedDataEntitySuccess{body: BookData.dodai()}
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 201
    assert Poison.decode!(res.body) == BookData.gear()
  end

  test "create/1 " <>
    "when request body is invalid " <>
    "it returns BadRequestError" do
    invalid_bodies = [
      %{                                       "author" => "author"},
      %{"title" => "",                         "author" => "author"},
      %{"title" => String.duplicate("a", 101), "author" => "author"},
      %{"title" => "body"},
      %{"title" => "body",                     "author" => ""},
      %{"title" => "body",                     "author" => String.duplicate("a", 51)},
    ]

    Enum.each(invalid_bodies, fn body ->
      res = Req.post_json(@api_prefix, body, @header)
      assert res.status               == 400
      assert Poison.decode!(res.body) == %{
        "code"        => "400-06",
        "description" => "Unable to understand the request.",
        "error"       => "BadRequest",
      }
    end)
  end
end
