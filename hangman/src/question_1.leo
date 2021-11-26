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
    //! 111. For example, can you instantiate a point p, and then negate it:
    let p
    let minus_p

    //! If you have spare time, why not create another point q and add it to p to make r.
    let q
    let r    
}