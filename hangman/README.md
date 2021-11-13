# Hangman

This example helps demonstrate how Leo can be used to build a game. Hangman has an element of committing to information on chain, and using that information to update the state of the game. As more functionality is added, this example can be expanded upon to work completely on chain. For now, the state of the chain prevents us from using this game as desired, although the code actually does almost everything we want it to from the perspective of what happens per 'turn' in the game.

## How to play
For now, Leo cannot create or consume records, and so this has to be done manually. Run the command `leo run`, and the first letter will be guesses of the dummy word. All the required info will be printed to the terminal, and this can be copied and pasted into the `hangman.in` file. Once copied over, change the letter to be guessed, and then run `leo clean` and then `leo run` again. The next turn of the game (guessing a new letter) will have then taken place. Repeat like this until the game is over.
