defmodule TougouBot.Anime do
  @moduledoc """
  The Anime module is in charge of handling searches for anime by using the 
  myanimelist api (https://myanimelist.net/modules.php?go=api)
  """
  use Alchemy.Cogs

  Cogs.set_parser(:vndb, &TougouBot.VNDB.custom_parser/1)
  Cogs.def mal(term) do
    results = search(term)
    Cogs.say(results)
  end
  #parser so that we search for not just the first word.
  def custom_parser(args) do
    args = String.split(args)
    args = rebuild_string(args)
    List.wrap(args)
  end
  def rebuild_string([head | []]) do
    head
  end
  def rebuild_string([head | tail]) do
    head<>"+"<>rebuild_string(tail)
  end

  #todo: way to select anime or manga
  defp search(term) do
    HTTPoison.start()
    case HTTPoison.get("https://myanimelist.net/api/anime|manga/search.xml?q="<>term) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body)
        body
      {:ok, %HTTPoison.Response{status_code: 204, body: body}} ->
        "No results"#todo: flavour text
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        "Invalid Credentials"#todo: flavour text
      {:error, %HTTPoison.Error{reason: e}} ->
        IO.inspect(e)
        "got a bad error, check log"#todo, flavour text.
    end
  end
end