// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Faucet {
    address public owner;
    uint public claimAmount = 1 ether;

    // keep track of addresses that have already claimed
    mapping(address => bool) public claimed;

    constructor() payable {
        owner = msg.sender; 
    }

    modifier onlyOwner {
       require(msg.sender == owner, "Only the owner can call this function");
       _;
    }

    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function setClaimAmount(uint newClaimAmount) public onlyOwner {
        claimAmount = newClaimAmount;
    }

    function donate() public payable {}

    function claimTokens(address payable claimer) public payable {
        require(address(this).balance > claimAmount, "Not enought funds in the faucet. Please donate");
        require(claimed[msg.sender] == false, "User has already claimed tokens.");

        claimer.transfer(claimAmount);

        // can only request 
        claimed[msg.sender] = true;
    }

    

}
