defmodule Example do
  def start(_type, _args) do
    words = ["car", "house", "bike", "tail", "hippopotomonstrosesquippedaliophobia"]
    state = words |> Enum.random |> HangMan.create_state
    HangMan.game_loop(state)
    Supervisor.start_link [], strategy: :one_for_one
  end
end