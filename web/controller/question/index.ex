use Croma

defmodule StackoverflowCloneB.Controller.Question.IndexRequestParams do
  use Croma.Struct, fields: [
    user_id: Croma.TypeGen.nilable(Croma.String),
    title: Croma.TypeGen.nilable(Croma.String),
    body: Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneB.Controller.Question.Index do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Error.BadRequestError
  alias StackoverflowCloneB.Controller.Question.{Helper, IndexRequestParams}

  defun index(%Conn{request: %Request{query_params: query_params}, context: context} = conn :: v[Conn.t]) :: Conn.t do
    #IO.inspect query_params["page"]

    case IndexRequestParams.new(query_params) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        #IO.inspect query_params #> [title: "\"こんにちは\""]
        query = convert_to_dodai_req_query(validated,query_params["page"])
        #data.title:"xxx"
        #IO.inspect query #>%Dodai.RetrieveDedicatedDataEntityListRequestQuery{limit: nil, query: %{"data.title" => "\"こんにちは\""}, skip: nil,sort: %{"_id" => 1}}
        req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
        %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = G2gClient.send(context, SD.app_id(), req)
        Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
    end
  end
  #Dodai上に渡すためにqueryの形を変換[title:"xxx"]->[data.title:"xxx"]
  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t],page) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    #IO.inspect params #>%StackoverflowCloneB.Controller.Question.IndexRequestParams{author: nil, title: "\"こんにちは\""}
    #IO.inspect Map.from_struct(params) #>%{author: nil, title: "\"こんにちは\""} #一旦マップに戻す
    #IO.inspect(Map.from_struct(params)|> Enum.reject(fn {_, value} -> is_nil(value) end)) #>[title: "\"こんにちは\""]　
    page = case page do
      nil -> 0
      "0" -> 0
        _ ->
          number_of_page = String.to_integer(page)
          if number_of_page < 0 do
            0
          else
            (number_of_page - 1) * 10
          end
      end
    query = Map.from_struct(params)
    #nilを除外する(指定していない値がNULLになるのを回避するため)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    #[title: "\"こんにちは\""] >[data.title,"こんにちは"]
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Map.new()
    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
      sort:  %{"createdAt" => 1},
      limit: 10,
      skip: page,
    }
  end
end
