defmodule StackoverflowCloneB.TestData.UserData do
  @dodai %{
    "_id"            => "user_id",
    "email"          => "test.user@example.com",
    "version"        => 0,
    "sections"       => [],
    "sectionAliases" => [],
    "rulesOfUser"    => [],
    "createdAt"      => "2017-02-10T01:37:49+00:00",
    "updatedAt"      => "2017-02-10T01:37:49+00:00",
    "data"           => %{},
    "readonly"       => %{},
    "rootonly"       => %{},
    "role"           => %{
      "groupWideAdmin" => false,
      "groupAppAdmin"  => false
    },
    "session"        => %{
      "key"               => "xxx",
      "expiresAt"         => "2018-02-27T05:18:43+00:00",
      "passwordSetAt"     => "2018-02-26T05:18:43+00:00",
      "passwordExpiresAt" => "2018-02-26T05:18:43+00:00",
    }
  }

  @gear Map.take(@dodai, ["email", "createdAt", "session"])
    |> StackoverflowCloneB.MapUtil.underscore_keys()
    |> Map.put("id", @dodai["_id"])

  def dodai(), do: @dodai
  def gear(),  do: @gear
end
