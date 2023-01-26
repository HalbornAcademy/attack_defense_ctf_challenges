// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Challenge.sol";

contract ChallengeDeploy is Script {
    Challenge public challenge;
    MiniMeToken public minimetoken;

    function run() public {
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.startBroadcast(owner);
        // 0x5fbdb2315678afecb367f032d93f642f64180aa3
        minimetoken = new MiniMeToken("HALToken", 18, "HAL", 10 ether);
        // 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
        challenge = new Challenge(address(minimetoken));

        minimetoken.approve(address(challenge), 10 ether);
        challenge.deposit(10 ether);

        assert(minimetoken.balanceOf(owner) == 0);

        vm.stopBroadcast();

    }
}
