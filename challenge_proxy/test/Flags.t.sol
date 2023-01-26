// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Proxy.sol";

contract FlagTest is Test {
    Implementation public impl;
    Proxy public proxy;

    function setUp() public {
        // 0x5fbdb2315678afecb367f032d93f642f64180aa3
        impl = Implementation(0x5FbDB2315678afecb367f032d93F642f64180aa3);

        // 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
        proxy = Proxy(0xe7f1725e7734ce288f8367e1bb143e90bb3f0512);
    }

    function testFlag1() public {
        if(proxy.testVariable() == 0) {
            revert("Test variable not set");
        }
    }

    function testFlag2() public {
        if(proxy.testVariable() == 0 || proxy.implementation() != address(impl)){
            revert("Test variable not set and proxy modified");
        }
    }

}
