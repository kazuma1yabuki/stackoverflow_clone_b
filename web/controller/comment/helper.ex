use Croma
defmodule StackoverflowCloneB.Controller.Comment.Helper do
  use StackoverflowCloneB.Controller.Application

  def get_comment_by_id(comments, target_id) do 
    Enum.at(Enum.filter(comments,fn (item) -> item["id"] == target_id end), 0)
  end

  def to_response_body(doc,target_id) do
	  #res_bodyの中でこの条件でフィルタ
    get_comment_by_id(doc["data"]["comments"], target_id)
    
  end
end
