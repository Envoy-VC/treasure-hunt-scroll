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
        bytes32[] memory publicInputs = new bytes32[](9);

        publicInputs[0] = bytes32(0x1bbce9cea5e7f0b77946a24ea35bbfec547d60fb1fd7eabc24478369d4c6d61a);
        publicInputs[1] = bytes32(0x2872e4a813d9da8cf8f3298cadb8bf22de5658571d081514f660f7669bcd994c);
        publicInputs[2] = bytes32(0x1e8bde3822665ae60296fd4d6072417000a46b2439afc34bc2138f08a14a9d9a);

        publicInputs[3] = bytes32(0x06e3828c348e040d12e17f6823e2ae6d75045df3a87cccbc8615a3a9e4883b38);
        publicInputs[4] = bytes32(0x029ea07c6f140ba740bf3ae4904fe9b8128804dcc0b1f17a03f7cb85e947408c);
        publicInputs[5] = bytes32(0x2f42c1aaeee52ebe7643cd3d9847a96809b95e153033cf3bdb26ede86501c042);

        publicInputs[6] = bytes32(0x0b4580226c6354964e91caf8e39e778e80314ac490038cf5474a818797c9aeb7);
        publicInputs[7] = bytes32(0x1ae4689a3fb9d86b27199fe529ed6125ee18308febef0809c3b5dc8dbdc07561);
        publicInputs[8] = bytes32(0x0255a6f0edfa87588206a8ecd349b2696e8a89ff58ddeb95bd211fbe8e0ba3c8);

        hunt.dig(proofBytes, publicInputs);
        vm.stopPrank();

        assertTrue(hunt.balances(user.addr) == initialBalance + hunt.REWARD_PER_DIG() - hunt.COST_PER_DIG());
    }
}
