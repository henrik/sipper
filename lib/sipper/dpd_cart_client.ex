defmodule Sipper.DpdCartClient do
  @subdomain "elixirsips"
  @feed_url "https://#{@subdomain}.dpdcart.com/feed"

  @feed_timeout_ms 15_000  # The default 5000 will time out sometimes.
  @file_timeout_ms 1000 * 60 * 60 * 3

  def get_feed!({_user, _pw} = auth) do
    response = HTTPotion.get(@feed_url, basic_auth: auth, timeout: @feed_timeout_ms)
    %HTTPotion.Response{body: body, status_code: 200} = response
    body
  end

  def get_file!({id, name}, {_user, _pw} = auth) do
    # TODO: Do this in curl to get progress?
    url = file_url(id, name)
    response = HTTPotion.get(url, basic_auth: auth, timeout: @file_timeout_ms)
    %HTTPotion.Response{body: body, status_code: 200} = response
    body
  end

  defp file_url(id, name) do
    "https://#{@subdomain}.dpdcart.com/feed/download/#{id}/#{name}"
  end
end
