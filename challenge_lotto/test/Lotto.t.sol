// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Lotto.sol";

contract LottoTest is Test {
    Lotto public lotto;

    address constant owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        vm.startPrank(owner);
        lotto = new Lotto();
    }

    function testInitialState() public {
        assertEq(lotto.gameId(), 1);
        vm.expectRevert("Need funds");
        lotto.play();
    }

    function testPlay() public {
        lotto.play{value: 0.5 ether}();
        (
            uint256 startBlock,
            uint256 endBlock,
            address winner,
            uint256 totalAmount,
            uint256 leftOverAmount
        ) = lotto.roundInfo(1);

        assertEq(startBlock, block.number);
        assertEq(endBlock, block.number + 5);
        assertEq(winner, owner);
        assertEq(totalAmount, 0.5 ether);
        assertEq(leftOverAmount, 0 ether);
    }

    function testPlayClaim() public {
        lotto.play{value: 0.5 ether}();
        vm.expectRevert("Round not finished");
        lotto.claimPrize();
    }

    function testPlayClaimNotDeployer() public {
        vm.stopPrank();
        lotto.play{value: 0.5 ether}();
        vm.prank(address(0));
        vm.expectRevert("Round not finished");
        lotto.claimPrize();

    }

    function testPlayClaimDone() public {
        uint256 beforePlayBalance = address(owner).balance;
        lotto.play{value: 0.5 ether}();
        vm.roll(block.number + 6);

        assertEq(address(owner).balance, beforePlayBalance - 0.5 ether);

        lotto.claimPrize();

        // Prize + left over
        assertEq(address(owner).balance, beforePlayBalance - 0.5 ether + 0.5 ether);

        (
            uint256 startBlock,
            uint256 endBlock,
            address winner,
            uint256 totalAmount,
            uint256 leftOverAmount
        ) = lotto.roundInfo(2);

        assertEq(startBlock, block.number);
        assertEq(endBlock, block.number + 5);
        assertEq(winner, address(0));
        assertEq(totalAmount, 0 ether);
        assertEq(leftOverAmount, 0 ether);
    }

}
