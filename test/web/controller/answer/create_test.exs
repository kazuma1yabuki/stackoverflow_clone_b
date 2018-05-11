defmodule StackoverflowCloneB.Controller.Answer.CreateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.AnswerData

  @api_prefix "/v1/answer"
  @header     %{}
  @body       %{"body" => "本文", "question_id" => "question_id"}

  test "create/1 " <>
    "Create answer test" do
      :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
        SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
      end)
      :meck.expect(G2gClient, :send, fn(_, _, req) ->
        assert req.body == %Dodai.CreateDedicatedDataEntityRequestBody{
          data: %{
            "body" => "body",
            "question_id" => "question_id",
            "user_id" => "user_id",
            "comments" => [],
            }
        }
        %Dodai.CreateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end)
  
      res = Req.post_json(@api_prefix, @body, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == AnswerData.gear()
    end
end
