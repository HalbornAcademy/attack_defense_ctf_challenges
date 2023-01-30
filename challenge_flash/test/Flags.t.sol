// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Flash.sol";

contract FlagTest is Test {
    FlashPool public pool;

    function setUp() public {
        // 0x5fbdb2315678afecb367f032d93f642f64180aa3
        pool = FlashPool(0x5FbDB2315678afecb367f032d93F642f64180aa3);
    }

    function testFlag1() public {
        if(address(pool).balance != 0 ether) {
            revert("Not drained");
        }
    }

}
