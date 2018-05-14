use Croma

defmodule StackoverflowCloneB.Controller.Comment.Create do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias SolomonLib.Time, as: Time
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Controller.Question.Helper, as: QuestionHelper
  # alias StackoverflowCloneB.Controller.Answer.Helper

  defmodule RequestBody do
    defmodule BodyString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,3000}$/
    end
  
    use Croma.Struct, fields: [
      body: BodyString,
    ]
  end

 plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def create(%Conn{request: %Request{path_info: path_info}} = conn) do

    [_, action, document_id, _] = path_info
    capitalized_action = String.capitalize(action)
    # question_action = QuestionHelper.collection_name()
    # answer_action = AnswerHelper.collection_name()
    case(capitalized_action) do
      "Question" ->
        updateCommentFromQuestion(conn, document_id)
      "Answer" ->
        IO.inspect "ANSWER "<>document_id
        # updateCommentFromQuestion(conn, document_id)
    end
  end

  def updateCommentFromQuestion(conn, document_id) do
    with_question(conn, document_id, fn question -> 
      if question["data"]["user_id"] == conn.assigns.me["_id"] do
        request_body = RequestBody.new(conn.request.body)
        case request_body do
          {:ok,_} ->
            comment_request = conn.request.body["body"]
            # question_comments = question["data"]["comments"]
            timestamp = Time.to_iso_timestamp(Time.now())
            user_id = conn.assigns.me["_id"]

            comment_body = %{
              "id"         => RandomString.stream(:alphanumeric) |> Enum.take(20) |> List.to_string,      # 上記の方法でランダムな文字列を生成
              "user_id"    => user_id,
              "body"       => comment_request,
              "created_at" => timestamp,
              }
            
            comment_request_body = %{ "comments" => comment_body }
            req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$push" => comment_request_body}}
            
            req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), QuestionHelper.collection_name(), document_id, SD.root_key(), req_body)
            %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
            Conn.json(conn, 200, QuestionHelper.to_response_body(res_body))
          {:error,_} ->
            ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.BadRequestError.new)
        end
      else
        ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.CredentialError.new())
      end
    end)
  end

  def with_question(conn, document_id, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), QuestionHelper.collection_name(), document_id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.ResourceNotFoundError.new())
    end
  end
end
