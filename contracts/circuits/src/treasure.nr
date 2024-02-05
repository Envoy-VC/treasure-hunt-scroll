use dep::std;

// treasure hunt game with multiple levels leading to a grand prize. 
// The game is played by a single player who must navigate through open world with a grid layout. he can roam freely on the map and he can choose to dig a site with varying depths such as 1 or 2 or 3. treasure can be found at any depth. The player can also choose to move to another location on the map. The game ends when the player finds the grand prize.

// The game is implemented using a 2D array to represent the map. There are riddles for each checkpoint and the answer is a string or some other thing.

struct Riddle {
    question: [u8; 32],
    answerHash: [u8; 32],
    position: Position,
}

struct Position {
    x: u8,
    y: u8,
}

pub fn getRiddles() -> [Riddle; 3] {
    let riddle = Riddle { question: [0; 32], answerHash: [0; 32], position: Position { x: 0, y: 0 } };
    let mut riddles: [Riddle; 3] = [riddle; 3];

    /*
    I am the block number on the Ethereum blockchain where The DAO incident took place. I caused a significant community discussion and a subsequent fork. Which block number am I?

    1920000

    [26,12]
    */

    let question1 = "I am the block number on the Ethereum blockchain where The DAO incident took place. I caused a significant community discussion and a subsequent fork. Which block number am I?".as_bytes();

    riddles[0] = Riddle {
        question: std::hash::keccak256(question1, question1.len() as u32),
        answerHash: std::hash::keccak256("1920000".as_bytes(), "1920000".as_bytes().len() as u32),
        position: Position { x: 26, y: 32 }
    };

    /*
        I am a consensus algorithm introduced to Ethereum to replace proof-of-work. I involve validators who lock up a certain amount of cryptocurrency to validate blocks. What is my name?

        Casper

        [32, 28]
    */

    let question2 = "I am a consensus algorithm introduced to Ethereum to replace proof-of-work. I involve validators who lock up a certain amount of cryptocurrency to validate blocks. What is my name?".as_bytes();

    riddles[1]  = Riddle {
        question: std::hash::keccak256(question2, question2.len() as u32),
        answerHash: std::hash::keccak256("Casper".as_bytes(), "Casper".as_bytes().len() as u32),
        position: Position { x: 34, y: 28 }
    };

    /*
        In 2014, I became the first cryptocurrency to implement the X11 hashing algorithm, aiming for increased security and energy efficiency. What is my name?

        Dash

        [4,2]
    */

    let question3 = "In 2014, I became the first cryptocurrency to implement the X11 hashing algorithm, aiming for increased security and energy efficiency. What is my name?".as_bytes();

    riddles[2] = Riddle {
        question: std::hash::keccak256(question3, question3.len() as u32),
        answerHash: std::hash::keccak256("Dash".as_bytes(), "Dash".as_bytes().len() as u32),
        position: Position { x: 4, y: 2 }
    };

    riddles
}

pub fn getRiddleForPos(pos: Position) -> Riddle {
    let riddles = getRiddles();

    let mut riddle = Riddle { question: [0; 32], answerHash: [0; 32], position: Position { x: 0, y: 0 } };

    for i in 0..3 {
        if {
            (riddles[i].position.x == pos.x) & (riddles[i].position.y == pos.y)
        } {
            riddle.question = riddles[i].question;
            riddle.answerHash = riddles[i].answerHash;
            riddle.position = riddles[i].position;
        }
    }

    riddle
}

pub fn solveRiddle(riddle: Riddle, answerHash: [u8; 32]) -> bool {
    let mut solved = false;

    if riddle.answerHash == answerHash {
        solved = true;
    }
    solved
}
