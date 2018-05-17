defmodule StackoverflowCloneB.TestData.VoteData do
    @body %{
        "like_voter_ids" => [
            "5976b4b037000037006d69c2",
            "5976b4b037000037006d69c3"
        ],
        "dislike_voter_ids" => [
            "5976b4b037000037006d69c4"
        ],
    }
    def dodai(), do: @body
end
  