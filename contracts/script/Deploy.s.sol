// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {TreasureHunt} from "../src/TreasureHunt.sol";
import {UltraVerifier} from "../src/circuits/plonk_vk.sol";

contract Deploy is Script {
    function run() external {
        TreasureHunt hunt;
        UltraVerifier verifier;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        verifier = new UltraVerifier();
        hunt = new TreasureHunt(address(verifier));

        vm.stopBroadcast();
    }
}
