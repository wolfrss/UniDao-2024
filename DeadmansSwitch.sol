// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastCheckIn;
    uint256 public checkInInterval;
    
    event Deposit(address indexed sender, uint256 amount);
    event FundsTransferred(uint256 amount, address indexed beneficiary);

    constructor(address _beneficiary, uint256 _checkInInterval) {
        owner = msg.sender;
        beneficiary = _beneficiary;
        checkInInterval = _checkInInterval;
        lastCheckIn = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function still_alive() public onlyOwner {
        lastCheckIn = block.number;
    }

    function transferFunds() public {
        require(block.number > lastCheckIn + checkInInterval, "Owner still active");
        uint256 balance = address(this).balance;
        payable(beneficiary).transfer(balance);
        emit FundsTransferred(balance, beneficiary);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    fallback() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
