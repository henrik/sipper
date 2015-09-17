defmodule SipperFeedParserTest do
  use ExUnit.Case

  test "extracting episodes and file links" do
    actual = Sipper.FeedParser.parse(feed_html)

    assert actual == [
      {
        "001 - Introduction and Installing Elixir",
        [
          { "1321", "001_Introduction_and_Installing_Elixir.mkv" },
          { "1366", "001_Introduction_and_Installing_Elixir.mp4" },
          { "1382", "001_Introduction_and_Installing_Elixir.md" },
        ],
      },
    ]
  end

  defp feed_html do
    """
    <rss>
      <channel>
        <item>
          <title><![CDATA[001 - Introduction and Installing Elixir]]></title>
          <link>https://elixirsips.dpdcart.com/subscriber/post?id=271</link>
          <description><![CDATA[<div class="blog-entry">
              <div class="blog-content"><p>In the first episode ever, I introduce Elixir Sips and walk through installing Erlang and Elixir</p>
              </div>
              <h3>Attached Files</h3>
              <ul>
              <li><a href="https://elixirsips.dpdcart.com/subscriber/download?file_id=1321">001_Introduction_and_Installing_Elixir.mkv</a></li>
    <li><a href="https://elixirsips.dpdcart.com/subscriber/download?file_id=1366">001_Introduction_and_Installing_Elixir.mp4</a></li>
    <li><a href="https://elixirsips.dpdcart.com/subscriber/download?file_id=1382">001_Introduction_and_Installing_Elixir.md</a></li>
    </ul></div>]]></description>
          <guid isPermaLink="false">dpd-e902c86df08867fcb3693be8cb5dd3985aecd62b</guid>
          <pubDate>Sun, 18 Aug 2013 22:10:00 -0400</pubDate>
          <enclosure url="https://elixirsips.dpdcart.com/feed/download/1366/001_Introduction_and_Installing_Elixir.mp4" length="68838997" type="video/mp4"/>
          <itunes:subtitle>In the first episode ever, I introduce Elixir Sips and walk through installing Erlang and Elixir</itunes:subtitle>
        </item>
      </channel>
    </rss>
    """
  end
end
