circuit Group {
    x: field,
    y: field,
}

circuit PedersenHash {
    x_parameters: [field; 256];
    y_parameters: [field; 256];


    // Instantiates a Pedersen hash circuit
    function new(x_parameters: [field; 256], y_parameters: [field; 256]) -> Self {
        return Self { x_parameters: x_parameters, y_parameters: y_parameters };
    }

    function hash(self, bits: [bool; 256]) -> Group {
        let digest: Group = Group { x: 0field, y: 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177field };
        for i in 0..256 {
            if bits[i] {
                digest = ec_add(digest, Group { x: self.x_parameters[i], y: self.y_parameters[i] });
            }
        }
        return digest;
    }
}

function ec_negate(p: Group) -> Group {
    return Group {
        x: p.x,
        y: -p.y,
    };
}

function ec_add(p: Group, q: Group) -> Group {
    let x_p = p.x;
    let x_q = q.x;
    let y_p = p.y;
    let y_q = q.y;

    let lam = (y_q - y_p) / (x_q - x_p);
    let x_r = lam * lam - x_p - x_q;
    let y_r = lam * (x_p - x_r) - y_p;

    return Group {
        x: x_r,
        y: y_r,
    };
}


// The 'pedersen-hash' main function.
function main(hash_input: [bool; 256], const x_parameters: [field; 256], const y_parameters: [field; 256]) -> (field, field) {
    const pedersen = PedersenHash::new(x_parameters, y_parameters);
    let hash = pedersen.hash(hash_input);
    return (hash.x, hash.y);
}
