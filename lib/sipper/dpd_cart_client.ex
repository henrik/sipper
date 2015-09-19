defmodule Sipper.DpdCartClient do
  @subdomain "elixirsips"
  @feed_url "https://#{@subdomain}.dpdcart.com/feed"

  @feed_timeout_ms 15_000  # The default 5000 will time out sometimes.
  @file_timeout_ms 1000 * 60 * 60 * 3

  def get_feed!({_user, _pw} = auth) do
    # We can't(?) get this with a meaningful progress bar, because the headers doesn't include a Content-Length.
    response = HTTPotion.get(@feed_url, basic_auth: auth, timeout: @feed_timeout_ms)
    %HTTPotion.Response{body: body, status_code: 200} = response
    body
  end

  def get_file(file, {_user, _pw} = auth, callback: cb) do
    url = file_url(file)
    HTTPotion.get(url, basic_auth: auth, timeout: @file_timeout_ms, stream_to: self)

    # The files in episode 89 (and maybe others) redirect to S3.
    # We'll optimistically assume all redirects are external with no need for auth.
    cb_plus_redirect_handling = fn
      {:redirect, new_url} -> get_external_file(new_url, cb)
      other -> cb.(other)
    end

    receive_file(cb_plus_redirect_handling)
  end

  defp get_external_file(url, callback) do
    HTTPotion.get(url, timeout: @file_timeout_ms, stream_to: self)
    receive_file(callback)
  end

  defp receive_file(callback) when is_function(callback) do
    receive_file(total_bytes: :unknown, data: "", callback: callback)
  end

  defp receive_file(total_bytes: total_bytes, data: data, callback: cb) do
    receive do
      %HTTPotion.AsyncHeaders{status_code: 302, headers: h} ->
        # A HTTP redirect.

        # We'll get an empty chunk and an "end", so let's get those out of the way.
        receive do: (%HTTPotion.AsyncChunk{chunk: ""} -> nil)
        receive do: (%HTTPotion.AsyncEnd{} -> nil)

        # Inform about the redirect so another request can be made.
        cb.({:redirect, h[:Location]})
      %HTTPotion.AsyncHeaders{status_code: 200, headers: h} ->
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

  defp file_url(%Sipper.File{id: id, name: name}) do
    "https://#{@subdomain}.dpdcart.com/feed/download/#{id}/#{name}"
  end
end
