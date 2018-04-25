defmodule StackoverflowCloneB.Controller.Book.UpdateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.BookData

  @api_prefix "/v1/book/book_id"
  @header     %{}
  @body       %{"title" => "new title"}

  test "update/1 " <>
    "should update book" do
    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      assert req.body == %Dodai.UpdateDedicatedDataEntityRequestBody{
        data: %{"$set" => %{title: "new title"}}
      }

      %Dodai.UpdateDedicatedDataEntitySuccess{body: BookData.dodai()}
    end)

    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == BookData.gear()
  end

  test "update/1 " <>
    "when request body is invalid " <>
    "it returns BadRequestError" do
    invalid_bodies = [
      %{"title" => "",                         "author" => "author"},
      %{"title" => String.duplicate("a", 101), "author" => "author"},
      %{"title" => "title",                    "author" => ""},
      %{"title" => "title",                    "author" => String.duplicate("a", 51)},
    ]

    Enum.each(invalid_bodies, fn body ->
      res = Req.put_json(@api_prefix, body, @header)
      assert res.status               == 400
      assert Poison.decode!(res.body) == %{
        "code"        => "400-06",
        "description" => "Unable to understand the request.",
        "error"       => "BadRequest",
      }
    end)
  end

  test "update/1 " <>
    "when specified book is not found " <>
    "it returns ResourceNotFoundError" do
    :meck.expect(G2gClient, :send, fn(_, _, _) -> %Dodai.ResourceNotFound{} end)

    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 404
    assert Poison.decode!(res.body) == %{
      "code"        => "404-04",
      "description" => "The resource does not exist in the database.",
      "error"       => "ResourceNotFound",
    }
  end
end
