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

  def get_file({id, name}, {_user, _pw} = auth, callback: cb) do
    url = file_url(id, name)
    response = HTTPotion.get(url, basic_auth: auth, timeout: @file_timeout_ms, stream_to: self)
    receive_file(total_bytes: :unknown, data: "", callback: cb)
  end

  defp receive_file(total_bytes: total_bytes, data: data, callback: cb) do
    receive do
      %HTTPotion.AsyncHeaders{headers: h} ->
        {total_bytes, _} = h[:"Content-Length"] |> Integer.parse
        cb.({:file_progress, 0, total_bytes})
        receive_file(total_bytes: total_bytes, data: data, callback: cb)
      %HTTPotion.AsyncChunk{chunk: new_data} ->
        accumulated_data = data <> new_data
        accumulated_bytes = byte_size(accumulated_data)
        cb.({:file_progress, accumulated_bytes, total_bytes})
        receive_file(total_bytes: total_bytes, data: accumulated_data, callback: cb)
      %HTTPotion.AsyncEnd{} ->
        cb.({:file_done, data})
    end
  end

  defp file_url(id, name) do
    "https://#{@subdomain}.dpdcart.com/feed/download/#{id}/#{name}"
  end
end
