// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Flash.sol";

contract ChallengeDeploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        // 0x5fbdb2315678afecb367f032d93f642f64180aa3
        FlashPool pool = new FlashPool();

        pool.deposit{value: 10 ether}();

        vm.stopBroadcast();

    }
}
