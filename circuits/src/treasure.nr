use dep::std;

struct Riddle {
    question: [u8; 32],
    answerHash: [u8; 32],
    position: [Field; 2],
}

pub fn getRiddles() -> [Riddle; 3] {
    let riddle = Riddle { question: [0; 32], answerHash: [0; 32], position: [0; 2] };

    let mut riddles: [Riddle; 3] = [riddle; 3];

    /*
    I am the block number on the Ethereum blockchain where The DAO incident took place. I caused a significant community discussion and a subsequent fork. Which block number am I?

    1920000

    [26,32]
    */

    riddles[0] = Riddle {
        question: getHash("I am the block number on the Ethereum blockchain where The DAO incident took place. I caused a significant community discussion and a subsequent fork. Which block number am I?".as_bytes()),
        answerHash: getHash("1920000".as_bytes()),
        position:[26,32]
    };

    /*
        I am a consensus algorithm introduced to Ethereum to replace proof-of-work. I involve validators who lock up a certain amount of cryptocurrency to validate blocks. What is my name?

        Casper

        [32, 28]
    */

    riddles[1] = Riddle {
        question: getHash("I am a consensus algorithm introduced to Ethereum to replace proof-of-work. I involve validators who lock up a certain amount of cryptocurrency to validate blocks. What is my name?".as_bytes()),
        answerHash: getHash("Casper".as_bytes()),
        position: [32, 28]
    };

    /*
        In 2014, I became the first cryptocurrency to implement the X11 hashing algorithm, aiming for increased security and energy efficiency. What is my name?

        Dash

        [4,2]
    */

    riddles[2] = Riddle {
        question: getHash("In 2014, I became the first cryptocurrency to implement the X11 hashing algorithm, aiming for increased security and energy efficiency. What is my name?".as_bytes()),
        answerHash: getHash("Dash".as_bytes()),
        position: [4,2]
    };

    riddles
}

pub fn getRiddleForPos(pos: [Field; 2]) -> Riddle {
    let riddles = getRiddles();

    let mut riddle = Riddle { question: [0; 32], answerHash: [0; 32], position: [0; 2] };

    for i in 0..3 {
        if {
            riddles[i].position == pos
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

pub fn getHash<N>(data: [u8; N]) -> [u8; 32] {
    std::hash::keccak256(data, N)
}
