// The program input for hangman/src/main.leo
[main]
create_game: bool = true;
word: [char; 20] = "aleons______________";
commitment_x: field = 0field;
commitment_y: field = 0field;
revealed: [char; 20] = "____________________";
used_guesses: [char; 10] = "__________";
guesses_left: u32 = 10;
victory: bool = false;

// Current guess (never to be const)
guess: char = 'b';

[constants]
word_length: u32 = 6;

// Saving these here so we can adjust the actual inputs without losing these
// create_game: bool = true;
// word: [char; 20] = "aleons______________";
// commitment_x: field = 0field;
// commitment_y: field = 0field;
// revealed: [char; 20] = ['_'; 20];
// used_guesses: [char; 10] = ['_'; 10];
// guesses_left: u32 = 10;
// victory: bool = false;

// Current guess (never to be const)
// guess: char = 'e';

// [constants]
// word_length: u32 = 6;

[registers]
r0: field = 0field;
r1: field = 0field;
r2: [char; 20] = ['_'; 20];
r3: [char; 10] = ['_'; 10];
r4: u32 = 10;
r5: bool = false;
