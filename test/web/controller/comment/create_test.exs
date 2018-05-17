defmodule StackoverflowCloneB.Controller.Comment.CreateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.AnswerData
  alias StackoverflowCloneB.TestData.CommentData
  alias StackoverflowCloneB.TestData.QuestionData

  @api_prefix_question "/v1/question/question_id/comment"
  @api_prefix_answer "/v1/answer/answer_id/comment"
  @header     %{"authorization" => "user_credential"}
  @body       %{"body" => "本文"}

  test "create/1 " <> 
    "Create comment at question test" do
    :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
      SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
    end)

    :meck.expect(SolomonLib.Time, :to_iso_timestamp, fn(_) ->
      "2018-02-18T01:01:00+00:00"
    end)

    :meck.expect(RandomString, :stream, fn(_) ->
      ["comment_id"]
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
            data: %{"$push" => 
                    %{"comments" => 
                      %{"body" => "本文",
                        "created_at" => "2018-02-18T01:01:00+00:00",
                        "id" => "comment_id", 
                        "user_id" => "user_id"}}
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
    res = Req.post_json(@api_prefix_question, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == CommentData.dodai()
  end

  test "create/1 " <> 
    "Create comment at answer test" do
    :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
      SolomonLib.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
    end)

    :meck.expect(SolomonLib.Time, :to_iso_timestamp, fn(_) ->
      "2018-02-18T01:01:00+00:00"
    end)

    :meck.expect(RandomString, :stream, fn(_) ->
      ["comment_id"]
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
            data: %{"$push" => 
                    %{"comments" => 
                      %{"body" => "本文",
                        "created_at" => "2018-02-18T01:01:00+00:00",
                        "id" => "comment_id", 
                        "user_id" => "user_id"}}
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
    res = Req.post_json(@api_prefix_answer, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == CommentData.dodai()
  end
end
