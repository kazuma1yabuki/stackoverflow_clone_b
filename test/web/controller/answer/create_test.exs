defmodule StackoverflowCloneB.Controller.Answer.CreateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.AnswerData
  alias StackoverflowCloneB.TestData.QuestionData

  @api_prefix "/v1/answer/"
  @header     %{"authentication" => "user_id"}
  @body       %{"body" => "本文", "question_id" => "question_id"}

  test "create/1 " <>
    "Create answer test" do
      :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
        SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
      end)
      :meck.expect(G2gClient, :send, fn(_, _, req) ->
        case req do
          %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
            # IO.inspect "======= RETRIEVE"
            assert retrieve_req.id == "question_id"
            %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
          %Dodai.CreateDedicatedDataEntityRequest{} = create_req ->
            # IO.inspect "======= CREATE"
            expected_request_body = %Dodai.CreateDedicatedDataEntityRequestBody{
              data: %{
                "body" => "本文", 
                "comments" => [], 
                "dislike_voter_ids" => [],
                "like_voter_ids" => [], 
                "question_id" => "question_id",
                "user_id" => "user_id",}
            }
            assert create_req.body == expected_request_body
            %Dodai.CreateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
        end
      end)
  
      res = Req.post_json(@api_prefix, @body, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == AnswerData.gear()
    end
end
