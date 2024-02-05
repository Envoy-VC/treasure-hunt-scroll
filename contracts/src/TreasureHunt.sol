// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {World} from "./lib/World.sol";
import {UltraVerifier} from "./circuits/plonk_vk.sol";

contract TreasureHunt {
    UltraVerifier public verifier;

    uint256 public constant COST_PER_DIG = 100;
    uint256 public constant REWARD_PER_DIG = 150;

    mapping(address => bool) public hasStarted;
    mapping(address => uint256) public balances;

    event GameStarted(address indexed player);
    event Dig(address indexed player);

    constructor(address _verifier) {
        verifier = UltraVerifier(_verifier);
    }

    function startGame() public {
        require(!hasStarted[msg.sender], "TreasureHunt: already started");
        hasStarted[msg.sender] = true;
        balances[msg.sender] = 1000;

        emit GameStarted(msg.sender);
    }

    function restartGame() public {
        require(hasStarted[msg.sender], "TreasureHunt: not started");
        hasStarted[msg.sender] = true;
        balances[msg.sender] = 1000;

        emit GameStarted(msg.sender);
    }

    function dig(bytes calldata _proof, bytes32[] calldata _publicInputs) public {
        bool verified = verifier.verify(_proof, _publicInputs);

        if (verified) {
            balances[msg.sender] += (REWARD_PER_DIG - COST_PER_DIG);
        } else {
            balances[msg.sender] -= COST_PER_DIG;
        }

        emit Dig(msg.sender);
    }
}
