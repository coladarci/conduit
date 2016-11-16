defmodule Conduit.Plug.LogIncoming do
  use Conduit.Plug.Builder
  require Logger
  @moduledoc """
  Logs an incoming message and how long it takes to process it.

  This is intended to be used in an incoming pipeline or subscriber.

      plug Conduit.Plug.LogIncoming

  The log level can be passed as an option. The default level is `:info`.

      plug Conduit.Plug.LogIncoming, log: :debug

  """

  def init(opts) do
    Keyword.get(opts, :log, :info)
  end

  def call(message, level) do
    start = System.monotonic_time()

    try do
      Logger.log(level, fn ->
        ["Processing message from ", message.source]
      end)

      super(message, level)
    after
      Logger.log(level, fn ->
        stop = System.monotonic_time()
        diff = System.convert_time_unit(stop - start, :native, :micro_seconds)

        ["Processed message from ", message.source, " in ", formatted_diff(diff)]
      end)
    end
  end

  defp formatted_diff(diff) when diff > 1000, do: [diff |> div(1000) |> Integer.to_string, "ms"]
  defp formatted_diff(diff), do: [diff |> Integer.to_string, "µs"]
end
