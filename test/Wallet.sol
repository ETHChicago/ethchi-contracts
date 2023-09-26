// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Wallet {

    address public wallet = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint256 public totalSupply = 0;
    address public owner;
    // uint public constant FEE = 50; // 2 percent

    mapping(address => uint) public balances;

    constructor(){
        owner = msg.sender;
    }

    function setWallet(address _address) public {
        wallet = _address;
    }

    function transfer(address _to, uint _amount) public {
        // Make sure the minimum value sent is at least 100, so when doing _amount / 50 it works alright.
        require(_amount >= 100, "A minimum of 100 need to be sent");
        uint256 fee = _amount; // / FEE;
        uint256 amountToBeSent = _amount - fee;
        balances[wallet] = fee;
        balances[_to] = amountToBeSent;
    }

    function getBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }

}