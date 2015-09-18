defmodule Sipper.DownloadWorker do
   use GenServer

   def start_link(_) do
     GenServer.start_link(__MODULE__, nil, [])
   end

   def fetch(worker_pid, data = {path, {id, name}, auth}) do
     GenServer.call(worker_pid, {:fetch, data}, :infinity)
   end

   def handle_call({:fetch, {path, {id, name}, auth}}, _from, state) do
      IO.puts "[DOWNLOADING] #{name}…"

      data = Sipper.DpdCartClient.get_file!({id, name}, auth)
      File.write!(path, data)

      IO.puts "[DONE!] #{name}"

     {:reply, nil, state}
   end
end
