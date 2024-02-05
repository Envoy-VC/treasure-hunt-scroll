// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2, Vm} from "forge-std/Test.sol";

import {TreasureHunt} from "../src/TreasureHunt.sol";
import {UltraVerifier} from "../src/circuits/plonk_vk.sol";

contract TreasureHuntTest is Test {
    TreasureHunt public hunt;
    UltraVerifier public verifier;

    Vm.Wallet public owner;
    Vm.Wallet public user;

    function setUp() public {
        owner = vm.createWallet("owner");
        user = vm.createWallet("user");

        vm.startPrank(owner.addr);
        verifier = new UltraVerifier();
        hunt = new TreasureHunt(address(verifier));
        vm.stopPrank();
    }

    function test_startGame() public {
        vm.startPrank(user.addr);
        hunt.startGame();
        vm.stopPrank();

        assertTrue(hunt.hasStarted(user.addr));
        assert(hunt.balances(user.addr) == 1000);
    }

    function test_correctDig() external {
        vm.startPrank(user.addr);
        hunt.startGame();
        uint256 initialBalance = hunt.balances(user.addr);
        string memory proof = vm.readLine("./proofs/circuits.proof");
        bytes memory proofBytes = vm.parseBytes(proof);

        hunt.dig(proofBytes, new bytes32[](0));
        vm.stopPrank();

        assertTrue(hunt.balances(user.addr) == initialBalance + hunt.REWARD_PER_DIG() - hunt.COST_PER_DIG());
    }
}
