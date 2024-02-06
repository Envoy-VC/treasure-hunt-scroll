mod treasure;
use dep::std;

fn main(position: pub [Field; 2], answerHash: [u8; 32]) {
    let riddle = treasure::getRiddleForPos(position);
    assert(riddle.position != [0, 0], "No Riddle found for position");

    let result = treasure::solveRiddle(riddle, answerHash);
    assert(result == true, "Riddle not solved");
}

#[test]
fn test_correct() {
    let position = [32, 28];
    let answerHash = treasure::getHash("Casper".as_bytes());
    println(answerHash);
    main(position, answerHash);
}

#[test(should_fail)]
fn test_wrong() {
    let position = [0, 0];
    let answerHash = treasure::getHash("Wrong".as_bytes());
    main(position, answerHash);
}
