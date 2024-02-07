use dep::std;

struct Riddle {
    question: Field,
    answerHash: Field,
    position: Field,
}

pub fn getRiddleForPos(pos: Field, riddles: [Riddle; 3]) -> Riddle {
    let mut riddle = Riddle { question: 0, answerHash: 0, position: 0 };

    for i in 0..3 {
        if {
            riddles[i].position == pos
        } {
            riddle = riddles[i];
        }
    }

    riddle
}

pub fn solveRiddle(riddle: Riddle, answerHash: Field) -> bool {
    let mut solved = false;

    if riddle.answerHash == answerHash {
        solved = true;
    }
    solved
}

pub fn getSolutionHash<M>(solution: [u8; 32], position: [Field; 2]) -> Field {
    let mut sol: [Field; 32] = u8ArrToFieldArr(solution);

    let solHash = std::hash::pedersen_hash(sol);
    let posHash = std::hash::pedersen_hash(position);

    let hash = std::hash::pedersen_hash([solHash, posHash]);
    hash
}

pub fn u8ArrToFieldArr<N>(data: [u8; N]) -> [Field; N] {
    let mut fieldData: [Field; N] = [0; N];
    for i in 0..N {
        fieldData[i] = data[i] as Field;
    }
    fieldData
}

pub fn constructRiddle<N, M>(question: [u8; N], position: [Field; 2], answerHash: [u8; 32]) -> Riddle {
    let questionHash = std::hash::pedersen_hash(u8ArrToFieldArr(question));
    let answerHash = getSolutionHash(answerHash, position);
    let positionHash = std::hash::pedersen_hash(position);

    let riddle = Riddle { question: questionHash, answerHash, position: positionHash };
    riddle
}
