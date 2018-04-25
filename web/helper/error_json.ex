use Croma

defmodule StackoverflowCloneB.Helper.ErrorJson do
  use SolomonLib.Controller

  defun json_by_error(conn :: v[Conn.t], %{code: code, name: name, description: description}) :: Conn.t do
    status = code |> String.split("-") |> List.first |> String.to_integer
    SolomonLib.Conn.json(conn, status, %{
      "code"        => code,
      "error"       => name,
      "description" => description,
    })
  end
end
