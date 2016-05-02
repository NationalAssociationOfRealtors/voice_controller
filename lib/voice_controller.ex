defmodule VoiceController do
    use Application
    require Logger

    @tty Application.get_env(:voice_controller, :tty)

    def start(_type, _args) do
        Logger.info "Opening TTY: #{@tty}"
        {:ok, pid} = VoiceController.Supervisor.start_link()
        Movi.add_handler(VoiceController.Handler)
        {:ok, self}
    end

end
