// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Flash.sol";

contract FlashTest is Test {
    FlashPool public flash;
    ReceiverMock public mock;

    address constant owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        vm.startPrank(owner);
        flash = new FlashPool();
        mock = new ReceiverMock(address(flash));
    }

    function testDeposit() public {
        uint256 before = address(flash).balance;
        uint256 before_balances = flash.balances(owner);

        flash.deposit{value: 1 ether}();

        assertEq(address(flash).balance, before + 1 ether);
        assertEq(flash.balances(owner), before_balances + 1 ether);
    }

    function testWithdraw() public {
        uint256 before = address(flash).balance;
        uint256 before_balances = flash.balances(owner);

        flash.deposit{value: 1 ether}();

        assertEq(address(flash).balance, before + 1 ether);
        assertEq(flash.balances(owner), before_balances + 1 ether);

        flash.withdraw();

        assertEq(address(flash).balance, before);
        assertEq(flash.balances(owner), before_balances);

    }

    function testFlashLoan() public {
        uint256 before = address(flash).balance;
        uint256 before_balances = flash.balances(owner);

        flash.deposit{value: 1 ether}();

        assertEq(address(flash).balance, before + 1 ether);
        assertEq(flash.balances(owner), before_balances + 1 ether);

        flash.flashLoan(address(mock), address(flash).balance);

        assertEq(address(flash).balance, before + 1 ether);
        assertEq(flash.balances(owner), before_balances + 1 ether);
    }
}
