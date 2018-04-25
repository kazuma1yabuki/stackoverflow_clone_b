use Croma

defmodule StackoverflowCloneB.NonEmptyString do
  use Croma.SubtypeOfString, pattern: ~r"\A.+\Z"
end
