// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Proxy.sol";

contract ProxyTest is Test {
    Proxy public proxy;
    Implementation public implementation_contract;
    Implementation public implementation;

    address constant owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        vm.startPrank(owner);
        implementation_contract = new Implementation();
        proxy = new Proxy(address(implementation_contract));
        implementation = Implementation(address(proxy));
    }

    function testIncrement(uint256 value) public {
        uint256 old_value = implementation.counter();
        implementation.incrementCounter(value);
        uint256 result = old_value;
        unchecked {
            result += value;
        }
        assertEq(uint(vm.load(address(implementation), 0)), result);
    }

    function testDecrement(uint256 value) public {
        uint256 old_value = implementation.counter();
        implementation.decrementCounter(value);
        uint256 result = old_value;
        unchecked {
            result -= value;
        }
        assertEq(uint(vm.load(address(implementation), 0)), result);
    }

    function testVariable() public {
        assertEq(proxy.testVariable(), 0);
    }

}
