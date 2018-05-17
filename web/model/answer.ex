use Croma

defmodule StackoverflowCloneB.Model.Answer do
  @moduledoc """
  Answer of StackoverflowCloneB app.
  """

  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,3000}\z/u
  end

  use AntikytheraAcs.Dodai.Model.Datastore, data_fields: [
    body:        Body,
    user_id:     StackoverflowCloneB.DodaiId,
    question_id: StackoverflowCloneB.DodaiId,
    comments:    StackoverflowCloneB.CommentList,
  ]
end
