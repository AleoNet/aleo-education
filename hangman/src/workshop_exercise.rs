// A circuit representing a point along an elliptic curve.
circuit Point {
    x: field,
    y: field,

    // Point negation
    function ec_negate(mut self) -> Self {
        return Self { x: self.x, y: -self.y};
    }
    
    // Point addition
    function ec_add(mut self, q: Point) -> Self {
        let x_p = self.x;
        let x_q = q.x;
        let y_p = self.y;
        let y_q = q.y;
    
        let lam = (y_q - y_p) / (x_q - x_p);
        let x_r = lam * lam - x_p - x_q;
        let y_r = lam * (x_p - x_r) - y_p;

        return Self {x: x_r, y: y_r};
    }

    //! 111. For example, can you instantiate a point p, and then negate it:
    //! let p
    //! let minus_p

    //! If you have spare time, why not create another point q and add it to p to make r.
    //! let q
    //! let r

}

// Circuit implementing the Pedersen hash function.
// Users must supply appropriate parameters to ensure that the resulting
// hash is a valid point on the desired curve.
circuit PedersenHash {
    digest: Point;
    x_parameters: [field; 256];
    y_parameters: [field; 256];

    // Instantiates a Pedersen hash circuit
    function new(digest: Point, const x_parameters: [field; 256], const y_parameters: [field; 256]) -> Self {
        return Self { digest: digest, x_parameters: x_parameters, y_parameters: y_parameters };
    }

    // Hashes a 256-bit array to a point on an elliptic curve.
    function hash(mut self, bits: [bool; 256]) -> Point {
        for i in 0..256 {
            if bits[i] {
                self.digest.ec_add(Point { x: self.x_parameters[i], y: self.y_parameters[i] });
            }
        }
        return self.digest;
    }
}


/// We are going to implement a game of Hangman in Leo. 
/// Before, we start writing code, let's go over some background information and design requirements.
/// Hangman is a game where a player attempts to guess all characters contained in a word.
/// A player wins if they are able to guess all characters within the allotted number of guesses. Otherwise, they lose.
/// 1. In our version of Hangman, words and guesses are restricted to the lowercase English alphabet.
/// 2. An invalid guess does not use up a guess.
/// TODO: Explain the purpose of the commitment scheme.
/// TODO: Explain console statements.
/// Note: Once done with the presentation, ask people to see if they can optimize the number of constraints in the circuit. Maybe they can organize the code in a better way? Maybe better use of constrol structures?
/// Note: What other functionality can you add? Maybe a lower bound on the number of guesses based on the number of unique characters?
circuit Hangman {
    //! 222. What variables should we have to represent the state of the game?
    //! You can use an array of chars, [char; 20], integers such as u32, and booleans.
    commitment: Point,
    // x_2
    // x_3
    // x_4
    // x_5
    

    // Returns true if `c` is a lowercase English alphabet letter.
    function valid_char(c: char) -> bool {
        const valid_chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];

        //! 333. Can you fill in the rest of this function? If the entered char `c' is
        //! in `valid_chars', we should set `is_valid_char' to true.
        // let is_valid_char = false;

        // return is_valid_char;
    }
    

    function new_game(word: [char; 20], const word_length: u32, guesses_left: u32) -> Self {
        // The `zero` group element for Edwards BLS12
        const digest: Point = Point { x: 0field, y: 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177field };

        // x and y coordiantes corresponding to the `one` group element.
        const x: field = 7810607721416582242904415504650443951498042435501746664987470571546413371306field;
        const y: field = 1867362672570137759132108893390349941423731440336755218616442213142473202417field;

        // We're not actually hashing the word here, we're hashing a "bitvector" where all bits are 1
        // A future release of Leo will have conversions to/from bits.
        let hasher = PedersenHash::new(digest, [x; 256], [y; 256]);
        let hash: Point = hasher.hash([true; 256]);

        // Number of guesses left cannot be greater than the maximum.
        if guesses_left > 10 {
            hash = Point{x: 0field, y: 0field};
        }

        // Validate the characters in the word.
        //! 444. We need to check that all the letters in the word are valid. If any
        //! of them are invalid, we should change the hash to Point{x: 0field, y: 0field};
        // for i in 0..word_length {
            
        // }

        // Check that word_length is of a valid size
        if word_length > 20 {
            hash = Point{x: 0field, y: 0field};
        }
    
        return Self { 
            commitment: hash, 
            revealed: ['_'; 20], 
            used_guesses: ['_'; 10], 
            guesses_left: 10u32, 
            victory: false
        };
    }

    //! 555. Now that we are guessing a letter, what do you think the input should be?
    //! And the ouput?
    function guess_letter() ->  {
        // Assume the guess has been entered correctly, and adjust this assumption if later checks fail
        let valid = true;

        // In future we can directly check if the entered word hashes to the same point as the hash in the game.
        // For now, we are just checking the letters are valid
        for i in 0..word_length {
            if Hangman::valid_char(word[i]) == false {
                valid = false;
            }
        }

        // Number of guesses left cannot be greater than the number of valid characters.
        if self.guesses_left > 10u32 {
            valid = false;
        }

        // Validate guessed letter
        valid = Hangman::valid_char(letter);

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
        //! 555. The player has chosen a letter to see if it is in the word. What 
        //! variables should we update? Can you fill in the code?
        // if valid {
            
        // }

        let victory = self.victory;
        if revealed == word {
            victory = true;
        }

        let commitment = self.commitment;
        return Self {commitment, revealed, used_guesses, guesses_left, victory};
    }

}

// The 'hangman' main function, which selectively creates a new game or runs the `guess_letter` function. 
function main(
    create_game: bool, 
    word: [char; 20], 
    const word_length: u32,
    commitment_x: field, 
    commitment_y: field,
    revealed: [char; 20], 
    used_guesses: [char; 10], 
    guesses_left: u32, 
    victory: bool, 
    guess: char
) -> (field, field, [char; 20], [char; 10], u32, bool) {
    let commitment = Point {x: commitment_x, y: commitment_y };
    let game = Hangman {commitment, revealed, used_guesses, guesses_left, victory};

    // The boolean variable `create_game` determines whether we are setting up a game (create_game = true),
    // or whether we are guessing a letter in an existing game (create_game = false).
    if create_game {
        game = Hangman::new_game(word, word_length, guesses_left);
    } else {
        game = game.guess_letter(word, word_length, guess);
    }

    // There is not yet functionality to create and consume records in Leo programs,
    // so instead we just print all the inputs we will need to update the state of the game
    console.log("
create_game: bool = false;
word: [char; 20] = \"{}\";
commitment_x: field = {};
commitment_y: field = {};
revealed: [char; 20] = \"{}\";
used_guesses: [char; 10] = \"{}\";
guesses_left: u32 = {};
victory: bool = {};", 
    word, game.commitment.x, game.commitment.y, game.revealed, game.used_guesses, game.guesses_left, game.victory);

    return (
        game.commitment.x,
        game.commitment.y,
        game.revealed, 
        game.used_guesses, 
        game.guesses_left, 
        game.victory
    );
}