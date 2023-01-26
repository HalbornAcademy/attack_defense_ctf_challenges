// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Challenge1.sol";

contract ChallengeTest is Test {
    Challenge1 public c;

    address constant owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        vm.startPrank(owner);
        c = new Challenge1();
    }

    function testInitialState() public {
        assertEq(c.owner(), owner);
        assertEq(address(c).balance, 0 ether);
        assertEq(c.totalBalance(), 0 ether);
    }

    function testDeposit() public {
        c.deposit{value: 1 ether}();
        assertEq(address(c).balance, 1 ether);
        assertEq(c.totalBalance(), 1 ether);
    }

    function testDepositNoOwner() public {
        vm.stopPrank();
        vm.prank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        vm.expectRevert();
        c.deposit{value: 1 ether}();
        assertEq(address(c).balance, 0 ether);
        assertEq(c.totalBalance(), 0 ether);
    }

    function testWithdraw() public {
        c.deposit{value: 1 ether}();
        c.emergencyWithdraw();
        assertEq(address(c).balance, 0 ether);
        assertEq(c.totalBalance(), 0 ether);
    }
}
