defmodule StackoverflowCloneB.Controller.Vote.CreateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.QuestionData
  alias StackoverflowCloneB.TestData.VoteData

  @api_prefix_like "/v1/question/question_id/vote/like_vote"
  @api_prefix_dislike "/v1/question/question_id/vote/dislike_vote"
  @header     %{"authorization" => "user_credential"}
  @body       %{}

  test "create/1 " <>
    "Test for like success" do
      :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
        SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
      end)

      :meck.expect(G2gClient, :send, fn(_, _, req) ->
        # IO.inspect "======= REQUEST"
        case req do
          %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
            # IO.inspect "======= RETRIEVE"
            assert retrieve_req.id == "question_id"
            %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
          %Dodai.UpdateDedicatedDataEntityRequest{} ->
            # IO.inspect "======= UPDATE"
            expected_req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{
              data: %{"$set" => %{
                        "like_voter_ids" => ["5976b4b037000037006d69c2",
                                             "5976b4b037000037006d69c3",
                                             "user_id"],
                        "dislike_voter_ids" => ["5976b4b037000037006d69c4"] }
                    }
            }
            assert req.body == expected_req_body
            %Dodai.UpdateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        end
      end)

      res = Req.post_json(@api_prefix_like, @body, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == VoteData.dodai()
  end

  test "create/1 " <>
    "Test for dislike success" do
      :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
        SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
      end)

      :meck.expect(G2gClient, :send, fn(_, _, req) ->
        # IO.inspect "======= REQUEST"
        case req do
          %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
            # IO.inspect "======= RETRIEVE"
            assert retrieve_req.id == "question_id"
            %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
          %Dodai.UpdateDedicatedDataEntityRequest{} ->
            # IO.inspect "======= UPDATE"
            expected_req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{
              data: %{"$set" => %{
                        "like_voter_ids" => ["5976b4b037000037006d69c2",
                                             "5976b4b037000037006d69c3"],
                        "dislike_voter_ids" => ["5976b4b037000037006d69c4", "user_id"] }
                    }
            }
            assert req.body == expected_req_body
            %Dodai.UpdateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        end
      end)

      res = Req.post_json(@api_prefix_dislike, @body, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == VoteData.dodai()
  end
end
