defmodule StackoverflowCloneB.Controller.Answer.UpdateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.AnswerData

  @api_prefix "/v1/answer/answer_id"
  @header     %{"authorization" => "user_credential"}
  @body       %{"body" => "body"}

  test "update/1 " <>
    "Test to update answer" do

      :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
        SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
      end)

      :meck.expect(G2gClient, :send, fn(_, _, req) ->
        # IO.inspect "======= REQUEST"
        case req do
          %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
            # IO.inspect "======= RETRIEVE"
            assert retrieve_req.id == "answer_id"
            %Dodai.RetrieveDedicatedDataEntitySuccess{body: AnswerData.dodai()}
          %Dodai.UpdateDedicatedDataEntityRequest{} = update_req ->
            # IO.inspect "======= UPDATE"
            expected_req = %Dodai.UpdateDedicatedDataEntityRequestBody{
              data: %{"$set" => %{"body" => "body"}}
            }
            assert update_req.body == expected_req
            %Dodai.UpdateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
        end
      end)

      res = Req.put_json(@api_prefix, @body, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == AnswerData.gear()
  end
end
