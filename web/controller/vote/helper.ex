use Croma

defmodule StackoverflowCloneB.Controller.Vote.Helper do
  use StackoverflowCloneB.Controller.Application

#   def find_vote_by_id(vote_list, target_id) do
#     Enum.filter(vote_list,fn (item) -> item == target_id end)
#   end

  def is_user_voted(vote_list, target_id) do
    Enum.member?(vote_list, target_id)
  end

  def to_response_body(doc) do
    %{
        "like_voter_ids" => doc["data"]["like_voter_ids"],
        "dislike_voter_ids" => doc["data"]["dislike_voter_ids"],
    }
  end
end