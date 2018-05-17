defmodule StackoverflowCloneB.CommonCase do
  use ExUnit.CaseTemplate
  using do
    quote do
      Module.put_attribute __MODULE__, :time,     {Antikythera.Time, {2017, 7, 20}, {1, 00, 00}, 000}
      Module.put_attribute __MODULE__, :conn,     Antikythera.Test.ConnHelper.make_conn()
      Module.put_attribute __MODULE__, :app_id,   "a_12345678"
      Module.put_attribute __MODULE__, :group_id, "g_12345678"

      setup do
        on_exit(&:meck.unload/0)
      end

      defp build_query_string(query_map) do
        strings = Enum.map(query_map, fn {name, value} ->
          name <> "=" <> encode_query_component_value(value)
        end)
        Enum.join(strings, "&")
      end

      defp encode_query_component_value(v) when is_map(v) or is_list(v) do
        v
        |> Poison.encode!
        |> encode_query_component_value()
      end

      defp encode_query_component_value(v) when is_binary(v) do
        URI.encode(v, &URI.char_unreserved?(&1))
      end

      defp encode_query_component_value(v) when is_integer(v) do
        Integer.to_string(v)
      end

      defp mock_fetch_me_plug(me) do
        :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _opts) ->
          Antikythera.Conn.assign(conn, :me, me)
        end)
      end
    end
  end
end
