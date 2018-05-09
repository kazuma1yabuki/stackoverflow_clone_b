defmodule StackoverflowCloneB.Controller.Question.Show do
  use StackoverflowCloneB.Controller.Application
  alias StackoverflowCloneB.Controller.Question.Helper
  alias StackoverflowCloneB.Error.ResourceNotFoundError

  def show(conn) do

    group_id = StackoverflowCloneB.Dodai.default_group_id()
    id = conn.request.path_matches[:id]
    root_key = StackoverflowCloneB.Dodai.root_key()
    app_id = StackoverflowCloneB.Dodai.app_id()

    request = Dodai.RetrieveDedicatedDataEntityRequest.new(group_id, Helper.collection_name(), id, root_key)
    response = Sazabi.G2gClient.send(conn.context, app_id, request)

    case response do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: resp_body} 
        -> Conn.json(conn, 200, Helper.to_response_body(resp_body))
      %Dodai.ResourceNotFound{} 
        -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end

  end
end
