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
                self.digest = self.digest.ec_add(Point { x: self.x_parameters[i], y: self.y_parameters[i] });
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
/// Note: Once done with the presentation, ask people to see if they can optimize the number of constraints in the circuit. Maybe they can organize the code in a better way? Maybe better use of constrol structures?
/// Note: What other functionality can you add? Maybe a lower bound on the number of guesses based on the number of unique characters?
circuit Hangman {
    // This is to ensure the player does not change their word
    commitment: Point,
    // This is the state of revealed letters
    revealed: [char; 20],
    // This is the state of used guesses
    used_guesses: [char; 10],
    guesses_left: u32,
    // This indicates if the game has been won yet
    victory: bool,
    

    // Returns true if `c` is a lowercase English alphabet letter.
    function valid_char(c: char) -> bool {
        const valid_chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];

        //! 333. Can you fill in the rest of this function? If the entered char `c' is
        //! in `valid_chars', we should set `is_valid_char' to true.
        let is_valid_char = false;
        for i in 0..26 {
            if c == valid_chars[i] {
                is_valid_char = true;
            }
        }
        return is_valid_char;
    }
    

    function new_game(word: [char; 20], const word_length: u32,) -> Self {
        // The `zero` group element for Edwards BLS12
        const digest: Point = Point { x: 0field, y: 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177field };

        // x and y coordiantes corresponding to the `one` group element.
        const x: field = 7810607721416582242904415504650443951498042435501746664987470571546413371306field;
        const y: field = 1867362672570137759132108893390349941423731440336755218616442213142473202417field;

        // We're not actually hashing the word here, we're hashing a "bitvector" where all bits are 1
        // A future release of Leo will have conversions to/from bits.
        let hasher = PedersenHash::new(digest, [x; 256], [y; 256]);
        let commitment: Point = hasher.hash([true; 256]);

        // Validate the characters in the word.
        //! 444. We need to check that all the letters in the word are valid. If any
        //! of them are invalid, we should change the commitment to Point{x: 0field, y: 0field};
        for i in 0..word_length {
            
        }

        // Check that word_length is of a valid size
        if word_length > 20 {
            commitment = Point{x: 0field, y: 0field};
        }
    
        return Self { 
            commitment: commitment, 
            revealed: ['_'; 20], 
            used_guesses: ['_'; 10], 
            guesses_left: 10u32, 
            victory: false
        };
    }

}

// The 'hangman' main function, which selectively creates a new game or runs the `guess_letter` function. 
function main() {
    let word = "aleons______________";
    const word_length = 6u32;
    let new_game = Hangman::new_game(word, word_length);
    console.log("the game says {}", new_game);
}