defmodule StackoverflowCloneB.Controller.Comment.UpdateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.AnswerData
  alias StackoverflowCloneB.TestData.CommentData
  alias StackoverflowCloneB.TestData.QuestionData

  @api_prefix_question "/v1/question/question_id/comment/comment_id"
  @api_prefix_answer "/v1/answer/answer_id/comment/comment_id"
  @header     %{"authorization" => "user_credential"}
  @body       %{"body" => "本文"}

  test "update/1 " <>
    "Update test for comment inside question" do
      :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
        SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
      end)

      :meck.expect(StackoverflowCloneB.Controller.Comment.Helper, :get_comment_by_id, fn(_, _) ->
        %{"body" => "本文",
          "created_at" => "2018-02-18T01:01:00+00:00",
          "id" => "comment_id", 
          "user_id" => "user_id"}
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
              data: %{"$set" => 
                      %{"comments" => 
                      [%{"body" => "本文1",
                        "created_at" => "2018-02-19T01:01:00+00:00", 
                        "id" => "comment_id1",
                        "user_id" => "5976b4b037000037006d69c0"},
                      %{"body" => "本文2", 
                      "created_at" => "2018-02-19T01:02:00+00:00",
                      "id" => "comment_id2", 
                      "user_id" => "5976b4b037000037006d69c1"}]}
              }
            }
            assert req.body == expected_req_body
            %Dodai.UpdateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        end
      end)
  
      :meck.expect(StackoverflowCloneB.Controller.Comment.Helper, :to_response_body, fn(_, _) ->
        %{"body" => "本文",
          "created_at" => "2018-02-18T01:01:00+00:00",
          "id" => "comment_id",
          "user_id" => "user_id"}
      end)

      res = Req.put_json(@api_prefix_question, @body, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == CommentData.dodai()
  end

  test "update/1 " <>
    "Update test for comment inside answer" do
      :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
        SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
      end)

      :meck.expect(StackoverflowCloneB.Controller.Comment.Helper, :get_comment_by_id, fn(_, _) ->
        %{"body" => "本文",
          "created_at" => "2018-02-18T01:01:00+00:00",
          "id" => "comment_id", 
          "user_id" => "user_id"}
      end)
  
      :meck.expect(G2gClient, :send, fn(_, _, req) ->
        # IO.inspect "======= REQUEST"
        case req do
          %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
            # IO.inspect "======= RETRIEVE"
            assert retrieve_req.id == "answer_id"
            %Dodai.RetrieveDedicatedDataEntitySuccess{body: AnswerData.dodai()}
          %Dodai.UpdateDedicatedDataEntityRequest{} ->
            # IO.inspect "======= UPDATE"
            expected_req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{
              data: %{"$set" => 
                      %{"comments" => 
                      [%{"body" => "本文1",
                        "created_at" => "2018-02-19T01:01:00+00:00", 
                        "id" => "comment_id1",
                        "user_id" => "5976b4b037000037006d69c0"},
                      %{"body" => "本文2", 
                      "created_at" => "2018-02-19T01:02:00+00:00",
                      "id" => "comment_id2", 
                      "user_id" => "5976b4b037000037006d69c1"}]}
              }
            }
            assert req.body == expected_req_body
            %Dodai.UpdateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
        end
      end)
  
      :meck.expect(StackoverflowCloneB.Controller.Comment.Helper, :to_response_body, fn(_, _) ->
        %{"body" => "本文",
          "created_at" => "2018-02-18T01:01:00+00:00",
          "id" => "comment_id",
          "user_id" => "user_id"}
      end)

      res = Req.put_json(@api_prefix_answer, @body, @header)
      assert res.status               == 200
      assert Poison.decode!(res.body) == CommentData.dodai()
  end
end
