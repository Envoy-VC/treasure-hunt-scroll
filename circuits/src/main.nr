mod treasure;
use dep::std;

fn main(riddles: pub [treasure::Riddle; 3], position: [Field; 2], answerHash: [u8; 32]) {
    let posHash = std::hash::pedersen_hash(position);
    let riddle = treasure::getRiddleForPos(posHash, riddles);

    assert(riddle.position == posHash, "No Riddle found for position");

    let result = treasure::solveRiddle(riddle, treasure::getSolutionHash(answerHash, position));
    assert(result == true, "Riddle not solved");
}

#[test]
fn test_correct() {
    let riddles  = getRiddles();
    let position = [32, 28];
    let answer = std::hash::keccak256("Casper".as_bytes(), "Casper".as_bytes().len() as u32);

    for i in 0..3 {
        print(riddles[i].question);
        print(riddles[i].answerHash);
        print(riddles[i].position);
    }

    main(riddles, position, answer);
}

fn getRiddles() -> [treasure::Riddle; 3] {
    let mut riddle = treasure::Riddle { question: 0, answerHash: 0, position: 0 };
    let mut riddles: [treasure::Riddle; 3] = [riddle; 3];

    riddles[0] = treasure::constructRiddle(
        "I am the block number on the Ethereum blockchain where The DAO incident took place. I caused a significant community discussion and a subsequent fork. Which block number am I?".as_bytes(),
        [26, 32],
        std::hash::keccak256("1920000".as_bytes(), "1920000".as_bytes().len() as u32)
    );

    riddles[1] = treasure::constructRiddle(
        "I am a consensus algorithm introduced to Ethereum to replace proof-of-work. I involve validators who lock up a certain amount of cryptocurrency to validate blocks. What is my name?".as_bytes(),
        [32, 28],
        std::hash::keccak256("Casper".as_bytes(), "Casper".as_bytes().len() as u32)
    );

    riddles[2] = treasure::constructRiddle(
        "In 2014, I became the first cryptocurrency to implement the X11 hashing algorithm, aiming for increased security and energy efficiency. What is my name?".as_bytes(),
        [4, 2],
        std::hash::keccak256("Dash".as_bytes(), "Dash".as_bytes().len() as u32)
    );

    riddles
}
