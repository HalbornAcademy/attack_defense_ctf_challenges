// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Challenge is ERC20, ReentrancyGuard {
    MiniMeToken public yoda;

    event Withdraw(address indexed beneficiary, uint256 amount);
    event Deposit(address indexed beneficiary, uint256 amount);

    // Define the Yoda token contract
    constructor(address _underlying) ERC20("xYODA", "xYODA") {
        yoda = MiniMeToken(_underlying);
    }

    function deposit(uint256 amount) external nonReentrant {
        // Gets the amount of YODA locked in the contract
        uint256 totalYoda = yoda.balanceOf(address(this));
        // Gets the amount of xYODA in existence
        uint256 totalShares = totalSupply();
        // If no xYODA exists, mint it 1:1 to the amount put in
        if (totalShares == 0 || totalYoda == 0) {
            _mint(msg.sender, amount);
        }
        // Calculate and mint the amount of xYODA the YODA is worth. The ratio will change overtime, as xYODA is burned/minted and YODA deposited + gained from fees / withdrawn.
        else {
            uint256 what = (amount * totalShares) / totalYoda;
            _mint(msg.sender, what);
        }
        // Lock the YODA in the contract
        yoda.transferFrom(msg.sender, address(this), amount);

        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 numberOfShares) external nonReentrant {
        // Gets the amount of xYODA in existence
        uint256 totalShares = totalSupply();
        // Calculates the amount of YODA the xYODA is worth
        uint256 what =
            (numberOfShares * yoda.balanceOf(address(this))) / totalShares;
        _burn(msg.sender, numberOfShares);
        yoda.transfer(msg.sender, what);

        emit Withdraw(msg.sender, what);
    }
}

contract MiniMeToken is Ownable {

    string public name;
    uint8 public decimals;
    string public symbol;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;

    constructor(
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol,
        uint256 initialSupply
    )
    {
        name = _tokenName;                                 // Set the name
        decimals = _decimalUnits;                          // Set the decimals
        symbol = _tokenSymbol;                             // Set the symbol
        _mint(msg.sender, initialSupply);
    }


    function transfer(address _to, uint256 _amount) public returns (bool success) {
        return doTransfer(msg.sender, _to, _amount);
    }


    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        if (allowed[_from][msg.sender] < _amount)
            return false;
        allowed[_from][msg.sender] -= _amount;
        return doTransfer(_from, _to, _amount);
    }


    function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
        if (_amount == 0) {
            return true;
        }
        require((_to != address(0)) && (_to != address(this)));

        if (balances[_from] < _amount) {
            return false;
        }

        balances[_from] = balances[_from] - _amount;
        require(balances[_to] + _amount >= balances[_to]); // Check for overflow
        balances[_to] = balances[_to] + _amount;

        emit Transfer(_from, _to, _amount);

        return true;
    }


    function approve(address _spender, uint256 _amount) public returns (bool success) {
        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));

        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
      return balances[_owner];
    }

    function _mint(address _owner, uint256 _amount) internal {
      balances[_owner] = _amount;
      totalSupply += _amount;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _amount
      );
}