use Croma
defmodule StackoverflowCloneB.Controller.Comment.Helper do
  use StackoverflowCloneB.Controller.Application

  def to_response_body(doc,target_id) do
	  #res_bodyの中でこの条件でフィルタ
    Enum.at(Enum.filter(doc["data"]["comments"],fn (item) -> item["id"] == target_id end), 0)
    
  end
end
