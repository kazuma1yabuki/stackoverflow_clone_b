defmodule StackoverflowCloneB.Repo.User do
  use SolomonAcs.Dodai.Repo.Users, [
    user_models: [StackoverflowCloneB.Model.User]
  ]
end
