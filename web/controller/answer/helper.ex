# web/controller/answer/helper.ex
use Croma
defmodule StackoverflowCloneB.Controller.Answer.Helper do
  use StackoverflowCloneB.Controller.Application

  @collection_name "Answer"

  defun collection_name() :: String.t do
    @collection_name
  end

  def to_response_body(doc) do
    base_map = %{
      "id"         => doc["_id"],
      "created_at" => doc["createdAt"],
    }
    Map.merge(doc["data"], base_map)
  end
end
