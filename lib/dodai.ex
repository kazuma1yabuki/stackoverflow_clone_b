use Croma

defmodule StackoverflowCloneB.Dodai do
  app_id   = "a_5xwfLJSx"
  group_id = "g_Q7RKs7cs"

  use AntikytheraAcs.Dodai.GearModule,
    app_id:                app_id,
    default_group_id:      group_id,
    default_client_config: %{recv_timeout: 10_000}

  def app_key(),  do: StackoverflowCloneB.get_env("app_key")
  def root_key(), do: StackoverflowCloneB.get_env("root_key")
end
