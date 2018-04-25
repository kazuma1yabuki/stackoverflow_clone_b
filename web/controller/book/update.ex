use Croma

defmodule StackoverflowCloneB.Controller.Book.UpdateRequestBody do
  alias StackoverflowCloneB.Controller.Book.Helper.Params

  use Croma.Struct, fields: [
    title:  Croma.TypeGen.nilable(Params.Title),
    author: Croma.TypeGen.nilable(Params.Author),
  ]
end

defmodule StackoverflowCloneB.Controller.Book.Update do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Error.{BadRequestError, ResourceNotFoundError}
  alias StackoverflowCloneB.Controller.Book.{Helper, UpdateRequestBody}

  defun update(%Conn{request: %Request{path_matches: %{id: id}, body: body}, context: context} = conn) :: Conn.t do
    case UpdateRequestBody.new(body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        set_data = Map.from_struct(validated) |> Enum.reject(fn {_, value} -> is_nil(value) end) |> Map.new()
        req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => set_data}}
        req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), Helper.collection_name(), id, SD.root_key(), req_body)
        res = G2gClient.send(context, SD.app_id(), req)
        case res do
          %Dodai.UpdateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
          %Dodai.ResourceNotFound{}                          -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
        end
    end
  end
end
