circuit Hangman {
    commitment: group,
    revealed: [char; 20],
    used_guesses: [char; 10],
    guesses_left: u32,
    victory: bool,

    function new_game(word: [char; 20]) -> Self {
        // We're not actually hashing my word here, we're hashing some constant thing.
        // This will be fixed when more functionality is added
        let hash: group = PedersenHash::new([1group; 256]).hash([true; 256]);
    
        return Self { 
            commitment: hash, 
            revealed: ['_'; 20], 
            used_guesses: ['_'; 10], 
            guesses_left: 10u32, 
            victory: false
        };
    }

    function guess_letter(self, word: [char; 20], letter: char) -> Self {
        let valid = true;

        // When support for (non-)equality of group elements is available, this check will need to be added.
        // if  commit_to_word(word, parameters) != self.commitment {
        //     valid = false;
        // }
        // let valid = false;
        // if commit_to_word(word) == self.commitment {
        //     valid = true;
        // }

        // Check that the letter has not already been guessed
        for i in 0..10 {
            if letter == self.used_guesses[i] {
                valid = false;
            }
        }
        // Check that the game is not over
        if self.guesses_left == 0 {
            valid = false;
        }  
        

        let revealed = self.revealed;
        let used_guesses = self.used_guesses;
        let guesses_left = self.guesses_left;
        // If everything is valid, see where the guessed letter is in the word
        if valid {
            for i in 0..20 {
                if word[i] == letter {
                    revealed[i] = letter;
                }
            }
            used_guesses[10 - guesses_left] = letter;
            guesses_left -= 1;
        }

        let victory = self.victory;
        if revealed == word {
            victory = true;
        }

        let commitment = self.commitment;
        return Self {commitment, revealed, used_guesses, guesses_left, victory};
    }

}

// The 'hangman' main function, which selectively runs the game setup or guess_letter action
function main(
    selector: bool, 
    word: [char; 20], 
    commitment: group, 
    revealed: [char; 20], 
    used_guesses: [char; 10], 
    guesses_left: u32, 
    victory: bool, 
    guess: char
) -> (group, [char; 20], [char; 10], u32, bool) {
    let game = Hangman {commitment, revealed, used_guesses, guesses_left, victory};
    // The selector bool determines whether we are setting up a game (selector = false),
    // or whether we are guessing a letter in an existing game (selectore = true).
    if selector {
        game = game.guess_letter(word, guess);
    } else {
        game = Hangman::new_game(word);
    }

    // There is not yet functionality to create and consume records in Leo programmes,
    // so instead we just print all the inputs we will need to update the state of the game for now
    console.log("
        selector: bool = true;
        word: [char; 20] = \"{}\";
        commitment: group = 1group;
        revealed: [char; 20] = \"{}\";
        used_guesses: [char; 10] = \"{}\";
        guesses_left: u32 = {};
        victory: bool = {};", 
    word, game.revealed, game.used_guesses, game.guesses_left, game.victory);

    return (
        game.commitment, 
        game.revealed, 
        game.used_guesses, 
        game.guesses_left, 
        game.victory
    );
}

function commit_to_word(word: [char; 20]) -> group {
    return PedersenHash::new([1group; 256]).hash([true; 256]);
}

// We need this hash to make the game work, and we do not want to add it as
// we would ususally add an import because the online palyground doesn't have 
// that functionality.
circuit PedersenHash {
    parameters: [group; 256],

    // Instantiates a Pedersen hash circuit
    function new(const parameters: [group; 256]) -> Self {
        return Self { parameters: parameters };
    }

    function hash(self, bits: [bool; 256]) -> group {
        let digest: group = 0group;
        for i in 0..256 {
            if bits[i] {
                digest += self.parameters[i];
            }
        }
        return digest;
    }
}

@test
function  test_main() {
    let word = "aacabababaabaabaacaa";
    let game = Hangman::new_game(word);
    let guess: char = 'b';

    let check = main(
        true, 
        word, 
        game.commitment, 
        game.revealed, 
        game.used_guesses, 
        game.guesses_left, 
        game.victory, 
        guess
    );
    let used_guesses = check.2;
    console.assert("b_________" == used_guesses);
}

// @test
// function  test_main() {
//     let word = "aacabababaabaabaacaa";
//     let game = Hangman::new_game(word);
//     let guess: char = 'b';

//     let check = main(true, word, game, guess);
//     console.assert("b_________" == check.used_guesses);
// }
