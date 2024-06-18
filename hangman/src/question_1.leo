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

function main() {
    //! 111. For example, can you instantiate a point p, and then negate it.
    //! You will need to use field elements, such as 0field, 1field, 2field, ...:
    //! When defining a struct such as a point, we do `Point{x_1: something, x_2: something}'
    let p = Point{x: 1, y: 1};
    let minus_p = p.ec_negate();
    console.log("the coordinates are {} and {}", minus_p.x, minus_p.y);

    //! If you have spare time, why not create another point q and add it to p to make r.
    let q = Point{x: 5, y: 3};
    let r = p.ec_add(q);
    console.log("r's x coordinate is {} and the y coordinate is {}", r.x, r.y);
}



//! What the .in file should be
//! The program input for hangman/src/main.leo
//! [main]
//! 
//! [registers]
//! r0: field = 0field;
