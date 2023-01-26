// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Lotto.sol";

contract FlagTest is Test {
    Lotto public lotto;

    function setUp() public {
        // 0x5fbdb2315678afecb367f032d93f642f64180aa3
        lotto = Lotto(0x5FbDB2315678afecb367f032d93F642f64180aa3);
    }

    function testFlag1() public {
        if(address(lotto).balance != 0 ether) {
            revert("Not drained");
        }

        bool wasExploited = false;

        for (uint256 i = 1; i <= lotto.gameId() ; i++) {
            (
                uint256 startBlock,
                uint256 endBlock,
                address winner,
                uint256 totalAmount,
                uint256 leftOverAmount
            ) = lotto.roundInfo(i);

            if(leftOverAmount != 0 && leftOverAmount == totalAmount) {
                wasExploited = true;
                break;
            }
        }

        if(!wasExploited) {
            revert("Keep on trying");
        }
    }

    // function testFlag2() public {
    // }

}
