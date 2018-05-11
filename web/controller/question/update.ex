use Croma
defmodule StackoverflowCloneB.Controller.Question.Update do
  use StackoverflowCloneB.Controller.Application
  alias StackoverflowCloneB.Dodai, as: SD
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Controller.Question.Helper

  defmodule RequestBody do
    defmodule TitleString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,100}$/
    end
    defmodule BodyString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,1000}$/
    end

    use Croma.Struct, fields: [
      title: Croma.TypeGen.nilable(TitleString), #conn.request.bodyをTitleStringで縛る
      body: Croma.TypeGen.nilable(BodyString),
    ]
  end

  plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def update(%Conn{request: %Request{path_matches: %{id: id}}, assigns: %{me: %{"_id" => _user_id}}} = conn) do
    # 指定されたidをもつquestionを取得する

    with_question(conn, fn question ->
      #IO.inspect question

      # questionのuser_idとログインユーザの_idが一致するか確認する(この判定ロジックを書いてみましょう)
      if question["data"]["user_id"] == conn.assigns.me["_id"] do
        ## 一致した場合
        ## 更新処理をする(下記の処理を書いてみましょう)
        rqbody = RequestBody.new(conn.request.body)
        #IO.inspect rqbody
          case rqbody do
            {:ok,_} ->
              ### 1. dodaiに対してrequestするrequest bodyを作成する
              req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => conn.request.body}}
              ### 2. dodaiに対してrequestするためのstructを作る
              req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", id, SD.root_key(), req_body)
              %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
              ### 3. クライアントにレスポンスを返す(dodaiのresponse bodyがいつもと違うことに注意)
              Conn.json(conn, 200, Helper.to_response_body(res_body))
            {:error,_} ->
              ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.BadRequestError.new)
          end
      else
        ## 一致しない場合、下記のようにエラーを返す
        ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.CredentialError.new())
      end
    end)
  end

  #質問が存在するかどうかを検証
  def with_question(%Conn{request: %Request{path_matches: %{id: id}}} = conn, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.ResourceNotFoundError.new())
    end
  end
end
