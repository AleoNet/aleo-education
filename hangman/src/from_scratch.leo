// This is provided in case you want to challenge yourself and build hangman from scratch.
// We provide some material, the kind of material that will be readily available in the future.
// This is an elliptic_curve_point, the Pedersen_hash, and the valid_char fucnciton.
// See if you can complete the programme


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
/// TODO: Explain the purpose of the commitment scheme.
/// TODO: Explain console statements.
/// Note: Once done with the presentation, ask people to see if they can optimize the number of constraints in the circuit. Maybe they can organize the code in a better way? Maybe better use of control structures?
/// Note: What other functionality can you add? Maybe a lower bound on the number of guesses based on the number of unique characters?
circuit Hangman {



    // Returns true if `c` is a lowercase English alphabet letter.
    // Can you reduce the number of constraints required to implement this function?
    function valid_char(c: char) -> bool {
        const valid_chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];

        let is_valid_char = false;
        for i in 0..26 {
            if c == valid_chars[i] {
                is_valid_char = true;
            }
        }
        return is_valid_char;
    }

}

// The 'hangman' main function, which selectively creates a new game or runs the `guess_letter` function. 
function main() {
    
    
    return
}





//! This should be used as the .in file
// // The program input for hangman/src/main.leo
// [main]
// create_game: bool = false;
// word: [char; 20] = "aleons______________";
// commitment_x: field = 0field;
// commitment_y: field = 0field;
// revealed: [char; 20] = "____________________";
// used_guesses: [char; 10] = "__________";
// guesses_left: u32 = 10;
// victory: bool = false;

// // Current guess (never to be const)
// guess: char = 'a';

// [constants]
// word_length: u32 = 6;

// // Saving these here so we can adjust the actual inputs without losing these
// // create_game: bool = true;
// // word: [char; 20] = "aleons______________";
// // commitment_x: field = 0field;
// // commitment_y: field = 0field;
// // revealed: [char; 20] = ['_'; 20];
// // used_guesses: [char; 10] = ['_'; 10];
// // guesses_left: u32 = 10;
// // victory: bool = false;

// // Current guess (never to be const)
// // guess: char = 'b';

// // [constants]
// // word_length: u32 = 6;

// [registers]
// r0: field = 0field;
// r1: field = 0field;
// r2: [char; 20] = ['_'; 20];
// r3: [char; 10] = ['_'; 10];
// r4: u32 = 10;
// r5: bool = false;
