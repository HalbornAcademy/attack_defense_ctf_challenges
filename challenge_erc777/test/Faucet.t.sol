// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Faucet.sol";
import "../src/ERC1820Registry.sol";

contract FaucetTest is Test {
    Faucet public faucet;
    ERC1820Registry public registry;

    function setUp() public {
        registry = new ERC1820Registry();
        faucet = new Faucet(new address[](0), address(registry));
        vm.warp(1000000);
    }

    function testInitialBalance() public {
        assertEq(faucet.balanceOf(address(faucet)), 10 ether);
    }

    function testGiveGold() public {
        address holder = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.startPrank(holder);
        uint256 beforeBalance = faucet.balanceOf(holder);
        faucet.giveMeGold();
        assertEq(faucet.balanceOf(holder), beforeBalance + 0.1 ether);
        vm.stopPrank();
    }

    function testWait() public {
        address holder = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.startPrank(holder);
        assertEq(faucet.balanceOf(holder), 0);
        faucet.giveMeGold();
        assertEq(faucet.balanceOf(holder), 0.1 ether);
        vm.expectRevert("Wait 1 hour for another request");
        faucet.giveMeGold();
        vm.warp(2000000);
        faucet.giveMeGold();
        vm.stopPrank();
    }

}
