use Croma

defmodule StackoverflowCloneB.Controller.Comment.Create do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias SolomonLib.Time, as: Time
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Controller.Comment.Helper

  defmodule RequestBody do
    defmodule CommentString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,1000}$/
    end

    use Croma.Struct, fields: [
      body: CommentString,
    ]
  end

  plug StackoverflowCloneB.Plug.FetchMe, :fetch, []


  # Connの中のrequestの中のpath_infoを参照？
  def create(%Conn{request: %Request{path_info: path_info}} = conn) do
    # path_info[VI/action("question" or "answer")/document_id(1495382~~~~(question_id or answer_id))/comment]からaction と document_idを参照
    [_, action, document_id, _] = path_info
    #actionの先頭文字列を大文字に
    capitalized_action = String.capitalize(action)
    #conn,capitalized_action,document_idを引数にもつ関数の定義
    updateCommentFromAction(conn, capitalized_action, document_id)
  end

  def updateCommentFromAction(conn, action, document_id) do
    with_action(conn, action, document_id, fn request_result ->
      target_id = request_result["_id"]
      rqbody = RequestBody.new(conn.request.body)

      case rqbody do
       {:ok,_} ->
        random_id = RandomString.stream(:alphanumeric) |> Enum.take(20) |> List.to_string
        timestamp = Time.to_iso_timestamp(Time.now())

        comment_data = %{
          "body"        => conn.request.body["body"],
          "id"          => random_id,
          "user_id"     => conn.assigns.me["_id"],
          "created_at"   => timestamp,
        }
        #comment_dataをcommentsとする
        comment_request_body = %{"comments" => comment_data}
        #dodaiに対してrequestするrequest bodyを作成する
        #comment_request_bodyをdata配列に追加する(push)
        req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$push" => comment_request_body}}
        ### 2. dodaiに対してrequestするためのstructを作る
        req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), action, target_id, SD.root_key(), req_body)
        %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
        ### 3. クライアントにレスポンスを返す(dodaiのresponse bodyがいつもと違うことに注意)
        Conn.json(conn,200,Helper.to_response_body(res_body,random_id))

       {:error,_} ->
        ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.BadRequestError.new)
      end
    end)
  end

  # With action: request the question or answer depends on the action whether the item
  # requested is available or not
  #質問/回答が存在するかどうかを検証
  def with_action(conn, capitalized_action, document_id, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), capitalized_action, document_id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.ResourceNotFoundError.new())
    end
  end
end


#bodyの中身をチェック
#connの中身をチェック
