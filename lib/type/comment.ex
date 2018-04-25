use Croma

defmodule StackoverflowCloneB.Comment do
  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,1000}\z/u
  end
  use Croma.Struct, recursive_new?: true, fields: [
    id:         StackoverflowCloneB.DodaiId,
    body:       Body,
    user_id:    StackoverflowCloneB.DodaiId,
    created_at: Croma.String,
  ]
end

defmodule StackoverflowCloneB.CommentList do
  use Croma.SubtypeOfList, elem_module: StackoverflowCloneB.Comment
end
