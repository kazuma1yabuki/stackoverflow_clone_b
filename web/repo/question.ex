use Croma

defmodule StackoverflowCloneB.Repo.Question do
  use AntikytheraAcs.Dodai.Repo.Datastore, [
    datastore_models: [StackoverflowCloneB.Model.Question],
  ]
end
