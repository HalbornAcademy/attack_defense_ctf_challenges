// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IFlashLoanEtherReceiver {
  function execute() external payable;
}

contract FlashPool {

  mapping(address => uint256) public balances;

  function deposit() external payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw() external {
    uint256 amountToWithdraw = balances[msg.sender];
    balances[msg.sender] = 0;
    payable(msg.sender).transfer(amountToWithdraw);
  }

  function flashLoan(address receiver, uint256 amount) external {
    uint256 balanceBefore = address(this).balance;
    require(balanceBefore >= amount, "Not enough ETH in balance");

    IFlashLoanEtherReceiver(receiver).execute{value: amount}();

    require(address(this).balance >= balanceBefore, "Flash loan hasn't been paid back");
  }
}

contract ReceiverMock is IFlashLoanEtherReceiver {
  FlashPool immutable pool;

  constructor(address target) {
    pool = FlashPool(target);
  }

  function execute() external payable override {
    // Return funds
    pool.deposit{value: msg.value}();
  }

  // required to receive ether
  receive() external payable {}
}