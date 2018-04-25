use Croma

defmodule StackoverflowCloneB.Controller.Book.IndexRequestParams do
  use Croma.Struct, fields: [
    title:  Croma.TypeGen.nilable(Croma.String),
    author: Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneB.Controller.Book.Index do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Error.BadRequestError
  alias StackoverflowCloneB.Controller.Book.{Helper, IndexRequestParams}

  defun index(%Conn{request: %Request{query_params: query_params}, context: context} = conn :: v[Conn.t]) :: Conn.t do
    case IndexRequestParams.new(query_params) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        query = convert_to_dodai_req_query(validated)
        req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
        %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = G2gClient.send(context, SD.app_id(), req)
        Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
    end
  end

  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t]) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    query = Map.from_struct(params)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Map.new()

    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
      sort:  %{"_id" => 1}
    }
  end
end
