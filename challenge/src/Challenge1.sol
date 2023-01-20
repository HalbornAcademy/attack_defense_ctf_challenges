// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Challenge1 {

    address public owner;
    uint256 public totalBalance;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable onlyOwner {
        totalBalance += msg.value;
    }

    function emergencyWithdraw() external {
        payable(msg.sender).call{value: totalBalance}("");
        totalBalance = 0;
    }

}
