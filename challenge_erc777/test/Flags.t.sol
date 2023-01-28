// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Faucet.sol";

contract FlagTest is Test {
    Faucet public faucet;

    function setUp() public {
        faucet = Faucet(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);
    }

    function testFlag1() public {
        if(faucet.balanceOf(address(faucet)) != 0 ether) {
            revert("Not drained");
        }
    }

}
