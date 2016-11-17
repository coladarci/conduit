defmodule Conduit.ContentType.JSON do
  use Conduit.ContentType
  @moduledoc """
  Handles converting a message body to and from JSON.
  """

  @doc """
  Formats the message body to json and sets the content type.

  ## Examples

      iex> import Conduit.Message
      iex> message =
      iex>   %Conduit.Message{}
      iex>   |> put_body(%{})
      iex>   |> Conduit.ContentType.JSON.format([])
      iex> message.body
      "{}"
      iex> get_meta(message, :content_type)
      "application/json"

  """
  def format(message, _opts) do
    message
    |> put_body(Poison.encode!(message.body))
    |> put_meta(:content_type, "application/json")
  end

  @doc """
  Parses the message body from json and sets the content type.

  ## Examples

      iex> import Conduit.Message
      iex> message =
      iex>   %Conduit.Message{}
      iex>   |> put_body("{}")
      iex>   |> Conduit.ContentType.JSON.parse([])
      iex> message.body
      %{}
      iex> get_meta(message, :content_type)
      "application/json"

  """
  def parse(message, _opts) do
    message
    |> put_body(Poison.decode!(message.body))
    |> put_meta(:content_type, "application/json")
  end
end
