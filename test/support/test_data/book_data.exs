defmodule StackoverflowCloneB.TestData.BookData do
  @dodai %{
    "_id"       => "id",
    "owner"     => "_root",
    "sections"  => [],
    "version"   => 0,
    "createdAt" => "2018-02-18T01:01:00+00:00",
    "updatedAt" => "2018-02-18T01:01:00+00:00",
    "data"      => %{
      "title"  => "title",
      "author" => "author",
    }
  }
  @gear Map.merge(@dodai["data"], %{"id" => @dodai["_id"]})

  def dodai(), do: @dodai
  def gear(),  do: @gear
end
