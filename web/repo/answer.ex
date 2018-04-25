use Croma

defmodule StackoverflowCloneB.Repo.Answer do
  use SolomonAcs.Dodai.Repo.Datastore, [
    datastore_models: [StackoverflowCloneB.Model.Answer],
  ]
end
