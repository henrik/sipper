# Files/attachments in the feed have a numeric ID and a filename.
# Both are required to generate a HTTP-authed URL.

defmodule Sipper.File do
  defstruct id: nil, name: nil
end
