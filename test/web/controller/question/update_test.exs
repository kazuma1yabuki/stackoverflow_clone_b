defmodule StackoverflowCloneB.Controller.Question.UpdateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.QuestionData

  @api_prefix "/v1/question/question_id"
  @header     %{"authorization" => "user_credential"}
  @body       %{"title" => "new title"}

  test "update/1 " <>
    "test to update question" do
      :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
        SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
      end)

      :meck.expect(G2gClient, :send, fn(_, _, req) ->
        # IO.inspect "======= REQUEST"
        case req do
          %Dodai.RetrieveDedicatedDataEntityRequest{} ->
            # IO.inspect "======= RETRIEVE"
            %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
            # %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => %{"title" => "new title"}}}
          %Dodai.UpdateDedicatedDataEntityRequest{} ->
            # IO.inspect "======= UPDATE"
            assert req.body == %Dodai.UpdateDedicatedDataEntityRequestBody{
              data: %{"$set" => %{"title" => "new title"}}
            }
            %Dodai.UpdateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        end
      end)

      res = Req.put_json(@api_prefix, @body, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == QuestionData.gear()
  end
end
