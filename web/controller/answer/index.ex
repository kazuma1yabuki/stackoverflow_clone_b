use Croma

defmodule StackoverflowCloneB.Controller.Answer.IndexRequestParams do
  use Croma.Struct, fields: [
    user_id: Croma.TypeGen.nilable(Croma.String),
    question_id: Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneB.Controller.Answer.Index do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Error.BadRequestError
  alias StackoverflowCloneB.Controller.Answer.{Helper, IndexRequestParams}

  defun index(%Conn{request: %Request{query_params: query_params}, context: context} = conn :: v[Conn.t]) :: Conn.t do
    case IndexRequestParams.new(query_params) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        #IO.inspect query_params #> [title: "\"こんにちは\""]
        query = convert_to_dodai_req_query(validated)
        #data.title:"xxx"
        #IO.inspect query #>%Dodai.RetrieveDedicatedDataEntityListRequestQuery{limit: nil, query: %{"data.title" => "\"こんにちは\""}, skip: nil,sort: %{"_id" => 1}}
        req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
        %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = G2gClient.send(context, SD.app_id(), req)
        Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
    end
  end
  #Dodai上に渡すためにqueryの形を変換[title:"xxx"]->[data.title:"xxx"]
  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t]) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    #IO.inspect params #>%StackoverflowCloneB.Controller.Answer.IndexRequestParams{author: nil, title: "\"こんにちは\""}
    #IO.inspect Map.from_struct(params) #>%{author: nil, title: "\"こんにちは\""} #一旦マップに戻す
    #IO.inspect(Map.from_struct(params)|> Enum.reject(fn {_, value} -> is_nil(value) end)) #>[title: "\"こんにちは\""]　
    query = Map.from_struct(params)
    #nilを除外する(指定していない値がNULLになるのを回避するため)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    #[title: "\"こんにちは\""] >[data.title,"こんにちは"]
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Map.new()
    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
      sort:  %{"createdAt" => 1}
    }
  end
end

# web/controller/answer/index.ex
#
# defmodule StackoverflowCloneB.Controller.Answer.Index do
#   use StackoverflowCloneB.Controller.Application
#   alias StackoverflowCloneB.Dodai, as: SD
#   alias StackoverflowCloneB.Controller.Answer.Helper
#
#   def index(conn) do
#     query = %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
#       query: %{},
#       sort:  %{"createdAt" => -1},
#     }
#     req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), "Answer", SD.root_key(), query)
#     %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
#     res_body = Enum.map(docs, &Helper.to_response_body(&1))
#
#     Conn.json(conn, 200, res_body)
#   end
# end
