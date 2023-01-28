// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Lotto {

    uint256 public constant PRIZE_PERCENTAGE = 90;
    uint256 public constant ROUND_BLOCKS = 5;
    uint256 public constant MIN_TO_PLAY = 0.1 ether;

    struct RoundInfo {
        uint256 startBlock;
        uint256 endBlock;
        address winner;
        uint256 totalAmount;

        uint256 leftOverAmount;
    }

    mapping(uint256 => RoundInfo) public roundInfo;

    uint256 public gameId;

    constructor()  {
        _startGame();
    }

    function _startGame() internal {
        // Start new game
        gameId += 1;
        roundInfo[gameId].startBlock = block.number;
        roundInfo[gameId].endBlock = block.number + ROUND_BLOCKS;
    }

    function play() external payable {
        require(msg.value > MIN_TO_PLAY, "Need funds");

        RoundInfo storage currentRound = roundInfo[gameId];

        require(block.number < currentRound.endBlock, "Round finished, claim prize");

        currentRound.winner = msg.sender;
        currentRound.totalAmount += msg.value;

    }

    // Anyone can call claimPrize
    function claimPrize() external {
        RoundInfo storage currentRound = roundInfo[gameId];

        require(block.number > currentRound.endBlock, "Round not finished");

        uint256 prize = currentRound.totalAmount * PRIZE_PERCENTAGE / 100;
        currentRound.winner.call{value: prize}("");

        currentRound.leftOverAmount = address(this).balance;
        msg.sender.call{value: currentRound.leftOverAmount}("");


        // New round
        _startGame();
    }

}