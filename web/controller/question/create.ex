use Croma

defmodule StackoverflowCloneB.Controller.Question.CreateRequestBody do
  alias StackoverflowCloneB.Controller.Question.Helper.Params

  use Croma.Struct, fields: [
    title:  Params.Title,
    body: Params.Body,
  ]
end

defmodule StackoverflowCloneB.Controller.Question.Create do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Controller.Question.{CreateRequestBody, Helper}
  alias StackoverflowCloneB.Error.BadRequestError
  alias StackoverflowCloneB.Dodai, as: SD

  plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def create(%Conn{request: %Request{body: body}} = conn) do
    case CreateRequestBody.new(body) do
      {:error, _} ->
        # IO.inspect body
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, _} ->
        # Prepare request data
        title = body["title"]
        body = body["body"]
        # title_length = String.length(title)
        # IO.inspect title_length
        
        sendRequest(conn, title, body)
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
        -> Conn.json(conn, 201, Helper.to_response_body(res_body))
      %Dodai.ResourceNotFound{}
        -> ErrorJson.json_by_error(conn, BadRequestError.new())
    end
  end
end
