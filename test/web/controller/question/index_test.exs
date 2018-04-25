defmodule StackoverflowCloneB.Controller.Question.IndexTest do
  use StackoverflowCloneB.CommonCase
  alias StackoverflowCloneB.TestData.QuestionData

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
end
