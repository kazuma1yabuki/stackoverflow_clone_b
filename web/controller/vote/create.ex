defmodule StackoverflowCloneB.Controller.Vote.Create do
  use StackoverflowCloneB.Controller.Application
  alias StackoverflowCloneB.Dodai, as: SD
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Error.{BadRequestError, ResourceNotFoundError}
  alias StackoverflowCloneB.Controller.Question.Helper, as: QuestionHelper
  alias StackoverflowCloneB.Controller.Vote.Helper

  # post "/v1/question/:id/vote/like_vote",    Vote.Create, :create
  # post "/v1/question/:id/vote/dislike_vote", Vote.Create, :create

  plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def create(%Conn{request: %Request{path_info: path_info}, assigns: %{me: %{"_id" => user_id}}} = conn) do
    [_, _, document_id, _, action] = path_info
    with_question(conn, document_id, fn request_result ->
      available_likes = request_result["data"]["like_voter_ids"]
      available_dislikes = request_result["data"]["dislike_voter_ids"]

      user_liked = Helper.is_user_voted(available_likes, user_id)
      user_disliked = Helper.is_user_voted(available_dislikes, user_id)
      case action do
        "like_vote" ->
          if user_liked do
            ErrorJson.json_by_error(conn, BadRequestError.new())
          else 
            available_dislikes = Enum.drop_while(available_dislikes, fn(item) -> 
              item == user_id
            end)
            available_likes = available_likes ++ [user_id]
            # add id to like list
            request_body = %{
              "like_voter_ids" => available_likes,
              "dislike_voter_ids" => available_dislikes
            }
            # IO.inspect request_body
            req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => request_body}}
            req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), QuestionHelper.collection_name(), document_id, SD.root_key(), req_body)
            %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
            Conn.json(conn,200,Helper.to_response_body(res_body))
          end
        "dislike_vote" ->
          if user_disliked do
            ErrorJson.json_by_error(conn, BadRequestError.new())
          else
            available_likes = Enum.drop_while(available_likes, fn(item) -> 
              item == user_id
            end) 
            available_dislikes = available_dislikes ++ [user_id]
            # add id to dislike list
            request_body = %{
              "like_voter_ids" => available_likes,
              "dislike_voter_ids" => available_dislikes
            }
            # IO.inspect request_body
            req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => request_body}}
            req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), QuestionHelper.collection_name(), document_id, SD.root_key(), req_body)
            %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
            Conn.json(conn, 200, Helper.to_response_body(res_body))
          end
      end
    end)
  end

  def with_question(conn, document_id, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), QuestionHelper.collection_name(), document_id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end
