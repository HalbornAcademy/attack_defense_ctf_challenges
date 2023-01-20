// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Challenge1.sol";

contract FlagTest is Test {
    Challenge1 public c;

    function setUp() public {
        c = Challenge1(0x5FbDB2315678afecb367f032d93F642f64180aa3);
    }

    function testFlag1() public {
        if(address(c).balance != 0 ether) {
            revert("Not drained");
        }
    }

    // function testFlag2() public {
    // }

}
