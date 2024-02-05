// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {World} from "./lib/World.sol";

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

    function getWorld() public pure returns (World.TerrainType[32][32] memory) {
        return World.getWorld();
    }
}
