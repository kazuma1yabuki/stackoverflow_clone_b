defmodule StackoverflowCloneB.Controller.Question.Create do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Controller.Question.Helper
  alias StackoverflowCloneB.Error.BadRequestError
  alias StackoverflowCloneB.Dodai, as: SD

  plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def create(conn) do
    # Prepare request data
    request_body = conn.request.body
    title = request_body["title"]
    body = request_body["body"]
    title_length = String.length(title)
    IO.inspect title_length
    if title_length < 100 do
      sendRequest(conn, title, body)
    else
      Conn.json(conn, 400, %{"message" => "Title shouldn't be more than 100"})
    end
    
  end

  defp sendRequest(conn, title, body) do
    user_id = conn.assigns.me["_id"]
    request_data = %{
      "comments"        => [],
      "like_voter_ids"    => [],
      "dislike_voter_ids" => [],
      "title"           => title,
      "body"            => body,
      "user_id"          => user_id,
    }

    req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: request_data}
    request = Dodai.CreateDedicatedDataEntityRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), req_body)
    response = G2gClient.send(conn.context, SD.app_id(), request)

    case response do
      %Dodai.CreateDedicatedDataEntitySuccess{body: res_body}
        -> Conn.json(conn, 201, %{"message" => Helper.to_response_body(res_body)})
      %Dodai.ResourceNotFound{}
        -> ErrorJson.json_by_error(conn, BadRequestError.new())
    end
  end
end
