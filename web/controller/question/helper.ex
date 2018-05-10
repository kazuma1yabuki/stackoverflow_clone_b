use Croma

defmodule StackoverflowCloneB.Controller.Question.Helper do
  use StackoverflowCloneB.Controller.Application

  defmodule Params do
    defmodule Title do
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,100}\z/u
    end
    defmodule Body do
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,1000}\z/u
    end
  end

  @collection_name "Question"

  defun collection_name() :: String.t do
    @collection_name
  end

  defun to_response_body(doc :: map) :: map do
    Map.merge(doc["data"], %{
      "id"         => doc["_id"],
      "created_at" => doc["createdAt"],
    })
  end
end
