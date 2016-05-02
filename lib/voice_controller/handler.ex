defmodule VoiceController.Handler do
    use GenEvent
    alias Movi.Event
    alias VoiceController.UDPServer
    alias VoiceController.UDPServer.Message

    def handle_event(event = %Event{:message => "LET THERE BE LIGHT"}, state) do
        IO.inspect event
        #UDPServer.send_message(%Message{:type => "light", :data => "on"})
        HTTPoison.get! "http://admin:Abudabu1!@192.168.1.11/api/sceneControl?id=12&action=start"
        {:ok, state}
    end

    def handle_event(event = %Event{:message => "GO DARK"}, state) do
        IO.inspect event
        #UDPServer.send_message(%Message{:type => "light", :data => "on"})
        HTTPoison.get! "http://admin:Abudabu1!@192.168.1.11/api/sceneControl?id=11&action=start"
        {:ok, state}
    end

    def handle_event(event = %Event{}, state) do
        IO.inspect event
        {:ok, state}
    end

end
