// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Faucet.sol";

contract FlagTest is Test {
    Faucet public faucet;

    function setUp() public {
        faucet = Faucet(0xe7f1725e7734ce288f8367e1bb143e90bb3f0512);
    }

    function testFlag1() public {
        if(address(faucet).balance != 0 ether) {
            revert("Not drained");
        }
    }

    // function testFlag2() public {
    // }

}
