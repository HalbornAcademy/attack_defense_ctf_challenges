// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Proxy {

    address public implementation;
    uint256 public testVariable;

    constructor(address _implementation) {
        implementation = _implementation;
        testVariable = 0;
    }

    fallback () external {
        address impl = implementation;

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}


contract Implementation {

    uint256 public counter;

    function incrementCounter(uint256 amount) external {
        unchecked {
            counter += amount;
        }
    }

    function decrementCounter(uint256 amount) external {
        unchecked {
            counter -= amount;
        }
    }

}
