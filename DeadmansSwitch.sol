// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.26;
contract DeadmansSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastCheckIn;
    uint256 public checkInInterval;

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
        payable(beneficiary).transfer(address(this).balance);
    }

    receive() external payable {}

    fallback() external payable {}
}