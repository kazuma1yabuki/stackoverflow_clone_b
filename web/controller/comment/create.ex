use Croma

defmodule StackoverflowCloneB.Controller.Comment.Create do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias SolomonLib.Time, as: Time
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Controller.Question.Helper, as: QuestionHelper
  alias StackoverflowCloneB.Controller.Answer.Helper, as: AnswerHelper

  defmodule RequestBody do
    defmodule BodyString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,1000}$/
    end
  
    use Croma.Struct, fields: [
      body: BodyString,
    ]
  end

 plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def create(%Conn{request: %Request{path_info: path_info}} = conn) do

    [_, action, document_id, _] = path_info
    capitalized_action = String.capitalize(action)
    updateCommentFromAction(conn, capitalized_action, document_id)
  end

  def updateCommentFromAction(conn, action, document_id) do
    with_action(conn, action, document_id, fn request_result -> 
      target_id = request_result["_id"]
      request_body = RequestBody.new(conn.request.body)
      case request_body do
        {:ok,_} ->
          comment_request = conn.request.body["body"]
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
          
          req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), action, target_id, SD.root_key(), req_body)
          %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
          case(action) do
            "Question" ->
              Conn.json(conn, 200, QuestionHelper.to_response_body(res_body))
            "Answer" ->
              Conn.json(conn, 200, AnswerHelper.to_response_body(res_body))
          end      
        {:error,_} ->
          ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.BadRequestError.new)
      end
    end)
  end

  # With action: request the question or answer depends on the action whether the item
  # requested is available or not
  def with_action(conn, action, document_id, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), action, document_id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.ResourceNotFoundError.new())
    end
  end
end
