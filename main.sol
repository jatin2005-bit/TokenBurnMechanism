
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeflationaryToken {

    string public name = "DeflationaryToken";
    string public symbol = "DEFL";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * (10 ** uint256(decimals)); // Total supply (1 million tokens with 18 decimals)
    uint256 public burnPercentage = 2; // Percentage of tokens to burn on each transfer

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply; // Assign all tokens to the contract creator initially
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        uint256 burnAmount = (amount * burnPercentage) / 100;
        uint256 transferAmount = amount - burnAmount;

        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount; // Reduce the sender's balance
        balanceOf[recipient] += transferAmount; // Increase the recipient's balance
        totalSupply -= burnAmount; // Reduce the total supply by the burned amount

        emit Transfer(msg.sender, recipient, transferAmount);
        emit Transfer(msg.sender, address(0), burnAmount); // Emit a burn event

        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        uint256 burnAmount = (amount * burnPercentage) / 100;
        uint256 transferAmount = amount - burnAmount;

        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Allowance exceeded");

        balanceOf[sender] -= amount; // Reduce the sender's balance
        balanceOf[recipient] += transferAmount; // Increase the recipient's balance
        allowance[sender][msg.sender] -= amount; // Decrease the allowance
        totalSupply -= burnAmount; // Reduce the total supply by the burned amount

        emit Transfer(sender, recipient, transferAmount);
        emit Transfer(sender, address(0), burnAmount); // Emit a burn event

        return true;
    }
}
