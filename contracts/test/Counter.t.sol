// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {World} from "../src//lib/World.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_getWorld() external {
        World.TerrainType[32][32] memory world = counter.getWorld();

        for (uint256 i = 0; i < 32; i++) {
            for (uint256 j = 0; j < 32; j++) {
                console2.log(uint256(world[i][j]), "");
            }
        }
    }
}
