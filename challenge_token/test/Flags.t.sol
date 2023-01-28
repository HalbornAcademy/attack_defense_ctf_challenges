// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Challenge.sol";

contract FlagTest is Test {

    Challenge public challenge;
    MiniMeToken public minimetoken;

    function setUp() public {
        // 0x5fbdb2315678afecb367f032d93f642f64180aa3
        minimetoken = MiniMeToken(0x5FbDB2315678afecb367f032d93F642f64180aa3);
        // 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
        challenge = Challenge(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);
    }

    function testFlag1() public {
        if(challenge.totalSupply() <= 10 ether){
            revert("Stake some yoda!");
        }
    }

    function testFlag2() public {
        if(minimetoken.balanceOf(address(challenge)) >= 10 ether){
            revert("Not drained!");
        }
    }

}
