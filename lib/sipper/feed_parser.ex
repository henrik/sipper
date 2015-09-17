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

    # Floki doesn't compensate well enough for borked HTML, so just regex this.
    file_tuples =
      ~r|<a href=".+/download\?file_id=(\d+)">(.+?)</a>|
      |> Regex.scan(description_html)
      |> Enum.map fn ([_, id, title]) -> {id, title} end

    { title, file_tuples }
  end
end
