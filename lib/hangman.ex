defmodule HangMan do
  def create_state(word \\ "Enter word: " |> IO.gets |> String.trim("\n")) do
    [
      alphabet: for(x <- 97..122, into: %{}, do: {<<x>>, 0}),
      word: word |> String.graphemes,
      lives: 5
    ]
  end

  def guess(state, letter) do
    if Keyword.get(state, :alphabet) |> Map.get(letter) == 1 do
      IO.puts "Letter already used!"
      Keyword.put(state, :lives, Keyword.get(state, :lives) - 1)
    else
      if Enum.member?(Keyword.get(state, :word), letter) do
          IO.puts "Letter in word!"
          state
        else
          IO.puts "Letter not in word!"
          Keyword.put(state, :lives, Keyword.get(state, :lives) - 1)
        end
      |>
      Keyword.put(
        :alphabet,
        Map.put(
          Keyword.get(state, :alphabet),
          letter, 1
        )
      )
    end
  end

  def view_word state do
    Enum.join(
      for letter <- Keyword.get(state, :word) do
        if Keyword.get(state, :alphabet) |> Map.get(letter) == 1, do: letter, else: "_"
      end,
      " "
    )
  end

  def view_stickman(state), do: state |> get_stickman |> Enum.join("\n")

  def get_stickman state do
    case Keyword.get(state, :lives) do
      5 ->
        [
          "     ",
          "     ",
          "     ",
          "     ",
          "     ",
          "_____"
        ]
      4 ->
        [
          "___  ",
          "|    ",
          "|    ",
          "|    ",
          "|    ",
          "|____"
        ]
      3 ->
        [
          "___  ",
          "|  | ",
          "|  O ",
          "|    ",
          "|    ",
          "|____"
        ]
      2 ->
        [
          "___  ",
          "|  | ",
          "|  O ",
          "|  | ",
          "|    ",
          "|____"
        ]
      1 ->
        [
          "___  ",
          "|  | ",
          "|  O ",
          "| /|\\",
          "|    ",
          "|____"
        ]
      0 ->
        [
          "___  ",
          "|  | ",
          "|  O ",
          "| /|\\",
          "| / \\",
          "|____"
        ]
      end
    end

    def view_game state do
      (for {v, i} <- state |> get_stickman |> Enum.with_index do
        case i do
          4 ->
            v <> " Lives: " <> Integer.to_string(Keyword.get(state, :lives))
          5 ->
            v <> " Word: " <> view_word(state)
          _ ->
            v
        end
      end
      |> Enum.join("\n"))
      <> "\nLetters used:" <> for {k1, v1} <- Keyword.get(state, :alphabet), v1 == 1, into: "", do: " " <> k1
    end

    def game_loop state do
      if Keyword.get(state, :lives) <= 0 do
        state |> view_stickman |> IO.puts
        IO.puts "Game over!\nWord: " <> ( Keyword.get(state, :word) |> Enum.join("") )
      else
        state |> view_game |> IO.puts
        guess = "Guess letter: " |> IO.gets |> String.trim("\n") |> String.downcase
        if for(x <- 97..122, do: <<x>>) |> Enum.any?(&(&1 == guess)) do
          HangMan.guess state, guess
        else
          IO.puts("Letter not valid!")
          state
        end
        |>
        game_loop
      end
    end
end