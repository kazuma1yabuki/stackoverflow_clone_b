defmodule StackoverflowCloneB.Controller.Question.Create do

  defmodule RequestBody do
    defmodule TitleString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,100}$/
    end
    defmodule BodyString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,1000}$/
    end

    use Croma.Struct, fields: [
      title: TitleString, #conn.request.bodyをTitleStringで縛る
      body: BodyString,
    ]
  end

  use StackoverflowCloneB.Controller.Application
  alias StackoverflowCloneB.Dodai, as: SD
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Controller.Question.Helper

  # headerのauthorizationを元にuserを取得する
  plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def create(conn) do
    # 作成するquestionのdataを組み立てる

    rqbody = RequestBody.new(conn.request.body)

      case rqbody do
        {:ok,_} ->
          data = %{
            "comments"        => [],
            "like_voter_ids"    => [],
            "dislike_voter_ids" => [],
            # titleとbodyはrequest bodyから取り出す
            "title"           => conn.request.body["title"],
            "body"            => conn.request.body["body"],
            "user_id"          => conn.assigns.me["_id"],
          }
          ## userの情報はconn.assigns.meに入っている
          ## 下記の行を追加して確認してみよう
          ## IO.inspect conn.assigns.me
          ## userの情報から_idの値を抜き出して下記を書き換えよう

          # 下記の手順で下記のdodaiのAPIに対してrequestする
          # https://github.com/access-company/Dodai-doc/blob/master/datastore_api.md#create-a-new-document

          # 1. request bodyのstructを作る
          # 上記で作成したdataをもとに作成する
          req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: data}
          #IO.inspect req_body.data
          # request structを作る
          # Dodai.CreateDedicatedDataEntityRequestBodyというstructを使っているが、なぜこのstructを使っているかは下記を参照。
          # https://docs.google.com/presentation/d/1er3W0P6syK8jRaLfBGy7y8yTU_HC2M1JNOdODuhh080/edit#slide=id.g39d382cebf_0_0
          # このstructを選ぶ理由を理解できるようにしておこう
          req = Dodai.CreateDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", SD.root_key(), req_body)
          # 2. requestを実行する
          %Dodai.CreateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
          # 3. responseを変換する
          # 下記の第三引数は上記のres_bodyを適切な形に変換したものに書き換えよう(to_response_body/1を使おう)
          Conn.json(conn, 200, Helper.to_response_body(res_body))
        {:error,_} ->
          ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.BadRequestError.new)
      end
  end

end
