# web/controller/answer/helper.ex

defmodule StackoverflowCloneB.Controller.Answer.Helper do
  use StackoverflowCloneB.Controller.Application

  def to_response_body(doc) do
    base_map = %{
      "id"         => doc["_id"],
      "created_at" => doc["createdAt"],
    }
    Map.merge(doc["data"], base_map)
  end
end
