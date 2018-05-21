 use Croma

defmodule StackoverflowCloneB.Controller.Answer.IndexRequestParams do
  use Croma.Struct, fields: [
    user_id: Croma.TypeGen.nilable(Croma.String),
    question_id: Croma.TypeGen.nilable(Croma.String),
    body: Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneB.Controller.Answer.Index do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Error.BadRequestError
  alias StackoverflowCloneB.Controller.Answer.{Helper, IndexRequestParams}

  defun index(%Conn{request: %Request{query_params: query_params}, context: context} = conn :: v[Conn.t]) :: Conn.t do
    #IO.inspect Request >solomonLib.Request
    #IO.inspect query_params >%{"user_id" => "5ae0129c38000038001da6ee"}
    #IO.inspect context %Antikythera.Context{context_id: "20180514-051637.691_y50-77226_0.599.0",executor_pool_id: {:gear, :stackoverflow_clone_b}, gear_entry_point: {StackoverflowCloneB.Controller.Answer.Index, :index}, gear_name: :stackoverflow_clone_b,start_time: {Antikythera.Time, {2018, 5, 14}, {5, 16, 37}, 691}}
    case IndexRequestParams.new(query_params) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        #IO.inspect query_params #> %{"user_id" => "5ae0129c38000038001da6ee"}
        query = convert_to_dodai_req_query(validated)
        #data.title:"xxx"
        #IO.inspect query #>%Dodai.RetrieveDedicatedDataEntityListRequestQuery{limit: nil, query: %{"data.user_id" => "5ae0129c38000038001da6ee"}, skip: nil,sort: %{"_id" => 1}}
        req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
        #IO.inspect SD.root_key
        %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = G2gClient.send(context, SD.app_id(), req)
        Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
    end
  end
  #Dodai上に渡すためにqueryの形を変換[title:"xxx"]->[data.title:"xxx"]
  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t]) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    #IO.inspect params #>%StackoverflowCloneB.Controller.Answer.IndexRequestParams{question_id: nil,user_id: "5ae0129c38000038001da6ee"}
    #IO.inspect Map.from_struct(params) #>%{question_id: nil, user_id: "5ae0129c38000038001da6ee"} #一旦マップに戻す
    #IO.inspect(Map.from_struct(params)|> Enum.reject(fn {_, value} -> is_nil(value) end)) #>[user_id: "5ae0129c38000038001da6ee"]
    query = Map.from_struct(params)
    #nilを除外する(指定していない値がNULLになるのを回避するため)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    #[title: "\"こんにちは\""] >[data.title,"こんにちは"]
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Map.new()
    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
      sort:  %{"createdAt" => -1}
    }
  end
end

# web/controller/answer/index.ex
# use Croma
#
# defmodule StackoverflowCloneB.Controller.Answer.IndexRequestParams do
#   use  Croma.Struct, fields: [
#     user_id: Croma.TypeGen.nilable(Croma.String),
#     question_id: Croma.TypeGen.nilable(Croma.String),
#   ]
# end
#
# defmodule StackoverflowCloneB.Controller.Answer.Index do
#   use StackoverflowCloneB.Controller.Application
#   alias StackoverflowCloneB.Dodai, as: SD
#   alias StackoverflowCloneB.Controller.Answer.{Helper,IndexRequestParams}
#   alias Sazabi.G2gClient
#     alias StackoverflowCloneB.Error.BadRequestError
#
#   defun index(%Conn{request: %Request{query_params: query_params}, context: context} = conn :: v[Conn.t]) :: Conn.t do
#     case IndexRequestParams.new(query_params) do
#       {:ok,validated} ->
#         query = convert_to_dodai_req_query(validated)
#         req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
#         %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = G2gClient.send(context, SD.app_id(), req)
#
#         Conn.json(conn, 200, Enum.map(docs,&Helper.to_response_body(&1)))
#       {:error, _} ->
#         ErrorJson.json_by_error(conn, BadRequestError.new())
#
#     end
#   end
#   defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t]) :: Dodai.RetrievededicatiedDataEntityListRequestQuery.t do
#     query = Map.from_struct(params)
#     |>Enum.reject(fn {_, value} -> is_nil(value) end)
#     |>Enum.map(fn {k, v} -> {"data.#{k}",v}end)
#     |>Map.new()
#
#     %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
#       query: query,
#       sort:  %{"createdAt" => 1}
#     }
#   end
# end
