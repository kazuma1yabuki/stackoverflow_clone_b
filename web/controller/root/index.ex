use Croma

defmodule StackoverflowCloneB.Controller.Root.Index do
  use StackoverflowCloneB.Controller.Application

  defun index(conn :: Conn.t) :: Conn.t do
    Conn.render(conn, 200, "root/index", [])
  end
end
