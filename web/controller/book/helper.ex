use Croma

defmodule StackoverflowCloneB.Controller.Book.Helper do
  defmodule Params do
    defmodule Title do
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,100}\z/u
    end
    defmodule Author do
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,50}\z/u
    end
  end

  @collection_name "Book"

  defun collection_name() :: String.t do
    @collection_name
  end

  defun to_response_body(map :: map) :: map do
    Map.fetch!(map, "data") |> Map.put("id", map["_id"])
  end
end
