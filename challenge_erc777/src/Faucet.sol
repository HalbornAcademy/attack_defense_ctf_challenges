pragma solidity ^0.8.0;

import "src/ERC777.sol";

contract Faucet is ERC777 {

    using Address for address;

    uint256 lastRequestTime;

    constructor(address[] memory defaultOperators, address _erc_1820_registry)
        ERC777("Gold", "GLD", defaultOperators, _erc_1820_registry)
    {
        _mint(address(this), 1 ether, "", "", false);
        lastRequestTime = 0;
    }


    function giveMeGold() external {

        require(block.timestamp > (lastRequestTime + 1 hours), "Wait 1 hour for another request");

        this.transfer(msg.sender, 0.1 ether);

        lastRequestTime = block.timestamp;

    }

}
