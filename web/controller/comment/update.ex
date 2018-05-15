use Croma

defmodule StackoverflowCloneB.Controller.Comment.Update do
  use StackoverflowCloneB.Controller.Application
  alias StackoverflowCloneB.Dodai, as: SD
  alias Sazabi.G2gClient
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

  def update(%Conn{request: %Request{path_info: path_info}} = conn) do
    [_, action, document_id, _, target_id] = path_info
    capitalized_action = String.capitalize(action)
    updateCommentFromAction(conn, capitalized_action, document_id, target_id)
  end

  def updateCommentFromAction(conn, action, document_id, target_id) do
    with_action(conn, action, document_id, fn request_result -> 
      # document_id_from_req = request_result["_id"]
      request_body = RequestBody.new(conn.request.body)
      case request_body do
        {:ok,_} ->
          comment_request = conn.request.body["body"]
          available_comments = request_result["data"]["comments"]
          
          # Took one and check user for update
          expected_comment = Enum.at(Enum.filter(available_comments, fn (item) -> item["id"] == target_id end), 0)
          if expected_comment["user_id"] == conn.assigns.me["_id"] do
            # update directly inside list
            # IO.inspect "BEFORE"
            # IO.inspect available_comments
            updated_comment = Enum.map(available_comments, fn(item) -> 
              if item["id"] == target_id do
                item |> Map.put("body", comment_request)
              else
                item
              end
            end)
            # IO.inspect "AFTER"
            # IO.inspect updated_comment

            comment_request_body = %{ "comments" => updated_comment }
            
            req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => comment_request_body}}
            req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), action, document_id, SD.root_key(), req_body)
            %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
            case(action) do
              "Question" ->
                Conn.json(conn, 200, QuestionHelper.to_response_body(res_body))
              "Answer" ->
                Conn.json(conn, 200, AnswerHelper.to_response_body(res_body))
            end
          else
            ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.CredentialError.new())
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
