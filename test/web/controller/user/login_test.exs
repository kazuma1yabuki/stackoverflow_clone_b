defmodule StackoverflowCloneB.Controller.User.LoginTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.UserData

  @user       UserData.dodai()
  @api_prefix "/v1/user/login"
  @header     %{"authorization" => "user_credential"}
  @body       %{
    "email"    => "test.user@example.com",
    "password" => "password",
  }

  test "login/1 " <>
    "it returns user document" do
    :meck.expect(G2gClient, :send, fn(_, _, req_body) ->
      assert req_body.body == %Dodai.UserLoginRequestBody{
        email: "test.user@example.com",
        password: "password"
      }

      %Dodai.UserLoginSuccess{body: @user}
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 201
    assert Poison.decode!(res.body) == UserData.gear()
  end

  test "login/1 " <>
    "when request body is invalid " <>
    "it returns BadRequestError" do
    mock_fetch_me_plug(%{"_id" => "user_id"})
    invalid_bodies = [
      %{},
      %{"email" => "test.user@example.com"},
      %{"email" => "",                      "password" => "password"},
      %{"email" => "test.user@example.com", "password" => ""},
    ]

    Enum.each(invalid_bodies, fn body ->
      res = Req.post_json(@api_prefix, body, @header)
      assert res.status               == 400
      assert Poison.decode!(res.body) == %{
        "code"        => "400-06",
        "description" => "Unable to understand the request.",
        "error"       => "BadRequest",
      }
    end)
  end

  test "login/1 " <>
    "when dodai returns AuthenticationError" <>
    "it returns AuthenticationError" do
    :meck.expect(G2gClient, :send, fn(_, _, _) ->
      %Dodai.AuthenticationError{
        code:        "401-01",
        description: "The given email, user name and/or password are incorrect.",
        name:        "AuthenticationError"
      }
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 401
    assert Poison.decode!(res.body) == %{
      "code"        => "401-01",
      "description" => "The given email, user name and/or password are incorrect.",
      "error"       => "AuthenticationError"
    }
  end
end
