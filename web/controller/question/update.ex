defmodule StackoverflowCloneB.Controller.Question.Update do
  use StackoverflowCloneB.Controller.Application
  alias StackoverflowCloneB.Dodai, as: SD
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Controller.Question.Helper
  alias StackoverflowCloneB.Error.{BadRequestError, ResourceNotFoundError}

  plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def update(%Conn{request: %Request{path_matches: %{id: id}}, assigns: %{me: %{"_id" => user_id}}} = conn) do
    with_question(conn, fn question ->
      IO.inspect "inside "<>id
      IO.inspect "inside userid "<>user_id
      question_owner = question["data"]["user_id"]
      IO.inspect question_owner
      
      if user_id == question_owner do        
          request_body = conn.request.body
          IO.inspect request_body
          request_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => request_body}}
          request = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), Helper.collection_name(), id, SD.root_key(), request_body)
          response = G2gClient.send(conn.context, SD.app_id(), request)
          case response do
            %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body}
              -> Conn.json(conn, 201, Helper.to_response_body(res_body))
            %Dodai.ResourceNotFound{}
              -> ErrorJson.json_by_error(conn, BadRequestError.new())
          end
        
      else 
        IO.inspect "failed"
        Conn.json(conn, 200, %{"message" => "failed"})
      end
    end)
  end

  def with_question(%Conn{request: %Request{path_matches: %{id: id}}} = conn, f) do
    IO.inspect "function "<>id
    request_body = conn.request.body
    IO.inspect request_body
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), Helper.collection_name(), id, SD.root_key())
    res = G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} 
        -> f.(body)
      %Dodai.ResourceNotFound{}                             
        -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end
