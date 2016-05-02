defmodule VoiceController.UDPServer do
    use GenServer
    require Logger

    defmodule Message do
        defstruct [:id, :type, :data, :ip, :port]
    end

    defmodule State do
        defstruct [:ip, :udp]
    end

    @port Application.get_env(:voice_controller, :port)
    @multicast Application.get_env(:voice_controller, :multicast_address)
    @interfaces ['wlan0', 'eth0']

    def start_link do
        GenServer.start(__MODULE__, @port, name: __MODULE__)
    end

    def send_message(message) do
        GenServer.call(__MODULE__, {:send, message})
    end

    def init(port) do
        intfs =
            :inet.getifaddrs()
            |> elem(1)
            |> Enum.find(fn(inf) ->
                Enum.member?(@interfaces, elem(inf, 0))
            end)
            |> elem(1)
        ip = intfs[:addr]
        Logger.info "Accepting datagrams on #{:inet_parse.ntoa(ip)}:#{port}"
        udp_options = [
            :binary,
            active:          10,
            add_membership:  { @multicast, {0,0,0,0} },
            multicast_if:    {0,0,0,0},
            multicast_loop:  false,
            multicast_ttl:   4,
            reuseaddr:       true
        ]
        {:ok, udp} = :gen_udp.open(port, udp_options)
        {:ok, %State{:udp => udp, :ip => ip}}
    end

    def handle_call({:send, message}, _from, state) do
        data = Poison.encode!(%Message{message | :ip => nil})
        Logger.info "Sending Message: #{data}"
        :ok = :gen_udp.send(state.udp, @multicast, @port, data)
        {:reply, :ok, state}
    end

end
