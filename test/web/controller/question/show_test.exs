defmodule StackoverflowCloneB.Controller.Question.ShowTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.QuestionData

  @api_prefix "/v1/question/question_id"

  test "show/1 " <>
    "it returns question" do
    :meck.expect(G2gClient, :send, fn(_, _, _) ->
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
    end)

    res = Req.get(@api_prefix)
    assert res.status               == 200
    assert Poison.decode!(res.body) == QuestionData.gear()
  end

  test "show/1 " <>
    "when specified question is not found " <>
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
