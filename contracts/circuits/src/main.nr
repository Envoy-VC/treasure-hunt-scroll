mod treasure;
use dep::std;

fn main(position: treasure::Position, answerHash: [u8; 32]) {
    let riddle = treasure::getRiddleForPos(position);
    assert(riddle.position.x != 0, "No Riddle found for position");

    let result = treasure::solveRiddle(riddle, answerHash);
    assert(result == true, "Riddle not solved");
}

#[test]
fn test_correct() {
    let position = treasure::Position { x: 34, y: 28 };
    let answer = "Casper".as_bytes();
    let answerHash = std::hash::keccak256(answer, answer.len() as u32);
    main(position, answerHash);
}

#[test(should_fail)]
fn test_wrong() {
    let position = treasure::Position { x: 0, y: 0 };
    let answerHash = [1; 32];
    main(position, answerHash);
}
