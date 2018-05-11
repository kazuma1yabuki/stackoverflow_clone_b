# web/controller/answer/index.ex

defmodule StackoverflowCloneB.Controller.Answer.Index do
  use StackoverflowCloneB.Controller.Application
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Controller.Answer.Helper

  def index(conn) do
    query = %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: %{},
      sort:  %{"_id" => 1},
    }
    req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), "Answer", SD.root_key(), query)
    %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    res_body = Enum.map(docs, &Helper.to_response_body(&1))

    Conn.json(conn, 200, res_body)
  end
end
