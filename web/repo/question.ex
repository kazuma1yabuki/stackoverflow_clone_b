use Croma

defmodule StackoverflowCloneB.Repo.Question do
  use SolomonAcs.Dodai.Repo.Datastore, [
    datastore_models: [StackoverflowCloneB.Model.Question],
  ]
end
