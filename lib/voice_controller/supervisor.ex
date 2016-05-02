defmodule VoiceController.Supervisor do
    use Supervisor

    @name __MODULE__
    @tty Application.get_env(:voice_controller, :tty)

    def start_link do
        Supervisor.start_link(__MODULE__, :ok, name: @name)
    end

    def init(:ok) do
        children = [
            worker(Movi, [@tty]),
            worker(VoiceController.UDPServer, []),
        ]
        supervise(children, strategy: :one_for_one)
    end
end
