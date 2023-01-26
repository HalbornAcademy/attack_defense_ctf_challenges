// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Proxy.sol";

contract ChallengeDeploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        // 0x5fbdb2315678afecb367f032d93f642f64180aa3
        Implementation impl = new Implementation();

        // 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
        Proxy proxy = new Proxy(address(impl));

        vm.stopBroadcast();

    }
}
