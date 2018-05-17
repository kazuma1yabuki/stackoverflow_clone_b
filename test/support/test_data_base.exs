defmodule StackoverflowCloneB.TestData.Base do
  @time       {Antikythera.Time, {2018, 2, 18}, {1, 1, 0}, 0}
  @model_base %{
    created_at: @time,
    updated_at: @time,
    owner:      "_root",
    version:    0,
  }

  def model_base(), do: @model_base
end
