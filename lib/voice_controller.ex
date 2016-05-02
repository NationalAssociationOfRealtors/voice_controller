defmodule VoiceController do
    use Application
    require Logger

    def start(_type, _args) do
        {:ok, pid} = VoiceController.Supervisor.start_link()
        Movi.add_handler(VoiceController.Handler)
        {:ok, pid}
    end

end
