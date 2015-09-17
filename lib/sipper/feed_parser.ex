defmodule Sipper.FeedParser do
  def parse(html) do
    html
    |> feed_items
    |> Enum.map &parse_item/1
  end

  defp feed_items(html) do
    html
    |> Floki.find("item")
  end

  defp parse_item(item) do
    title = item |> Floki.find("title") |> Floki.text

    description_html = item |> Floki.find("description") |> Floki.text

    file_links =
      description_html
      |> Floki.find("a")
      |> Enum.filter fn (a) ->
        a |> href |> String.contains?("download?file_id=")
      end

    file_tuples =
      Enum.map file_links, fn (link) ->
        [_, id] = Regex.run(~r/file_id=(\d+)/, link |> href)
        title = link |> Floki.text

        { id, title }
      end

    files = file_links

    { title, file_tuples }
  end

  defp href(a) do
    a |> Floki.attribute("href") |> hd
  end
end
