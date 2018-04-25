defmodule StackoverflowCloneB.Controller.StaticFile.ShowTest do
  use StackoverflowCloneB.CommonCase

  @files [
    %{
      url:          "/robots.txt",
      content_type: "text/plain",
    },
  ]

  test "show/1 " <>
       "should return static file" do

    Enum.map(@files, fn(%{url: url, content_type: content_type}) ->
      res = Req.get(url)
      file_path = Path.join([__DIR__, "../../../..", "priv/static", url])

      assert res.status                  == 200
      assert res.headers["content-type"] == content_type
      assert res.body                    == File.read!(file_path)
    end)
  end
end
