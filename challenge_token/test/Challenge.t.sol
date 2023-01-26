// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Challenge.sol";

contract CounterTest is Test {
    Challenge public challenge;
    MiniMeToken public minimetoken;

    function setUp() public {
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.startPrank(owner);
        // 0x5fbdb2315678afecb367f032d93f642f64180aa3
        minimetoken = new MiniMeToken("HALToken", 18, "HAL", 1000);
        vm.stopPrank();
        // 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
        challenge = new Challenge(address(minimetoken));
    }

    function testToken() public {
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address owner2 = 0xF39Fd6E51aAd88f6f4cE6Ab8827279CFfFb92265;
        // minimetoken.mint(owner, 1000);
        assertEq(minimetoken.balanceOf(owner), 1000);
        assertEq(minimetoken.balanceOf(owner2), 0);

        vm.startPrank(owner);
        minimetoken.transfer(owner2, 500);
        vm.stopPrank();

        assertEq(minimetoken.balanceOf(owner), 500);
        assertEq(minimetoken.balanceOf(owner2), 500);

        vm.startPrank(owner);
        minimetoken.approve(owner2, 100);
        assertEq(minimetoken.allowance(owner, owner2), 100);
        vm.stopPrank();

        vm.startPrank(owner2);
        minimetoken.transferFrom(owner, owner2, 100);
        vm.stopPrank();

        assertEq(minimetoken.balanceOf(owner), 400);
        assertEq(minimetoken.balanceOf(owner2), 600);
    }

    function testDeposit() public {
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        assertEq(minimetoken.balanceOf(owner), 1000);

        vm.startPrank(owner);
        minimetoken.approve(address(challenge), 1000);
        challenge.deposit(1000);
        vm.stopPrank();

        assertEq(minimetoken.balanceOf(owner), 0);
        assertEq(challenge.balanceOf(owner), 1000);
    }

    function testWithdraw() public {
        address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

        vm.startPrank(owner);
        minimetoken.approve(address(challenge), 1000);
        challenge.deposit(1000);

        ///

        challenge.withdraw(1000);
        vm.stopPrank();

        assertEq(minimetoken.balanceOf(owner), 1000);
        assertEq(challenge.balanceOf(owner), 0);
    }
}
