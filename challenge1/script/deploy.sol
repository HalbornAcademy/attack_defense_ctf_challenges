// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Challenge1.sol";

contract ChallengeDeploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        Challenge1 c = new Challenge1();
        c.deposit{value: 1 ether}();
        vm.stopBroadcast();

    }
}
