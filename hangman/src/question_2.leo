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

    //! 111. For example, can you instantiate a point p, and then negate it.
    //! You will need to use field elements, such as 0field, 1field, 2field, ...:
    //! When defining a struct such as a point, we do `Point{x_1: something, x_2: something}'
    // let p = Point{x: 1, y: 1};
    // let minus_p = p.ec_negate();
    // console.log("the coordinates are {} and {}", minus_p.x, minus_p.y);

    //! If you have spare time, why not create another point q and add it to p to make r.
    // let q = Point{x: 5, y: 3};
    // let r = p.ec_add(q);
    // console.log("r's x coordinate is {} and the y coordinate is {}", r.x, r.y);
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
    //! 222. What variables should we have to represent the state of the game?
    //! You can use an array of chars, [char; 20], integers such as u32, and booleans.
    commitment: Point,
    x_2
    x_3
    x_4
    x_5
    
}

// The 'hangman' main function, which selectively creates a new game or runs the `guess_letter` function. 
function main() {
    let new_game = Hangman {};
}
