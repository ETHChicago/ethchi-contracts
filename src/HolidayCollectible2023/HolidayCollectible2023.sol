// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract HolidayCollectible2023 is ERC1155, Ownable {
    bool public mintOpen = true; 
    uint256 public nextId = 0;

    modifier canMint() {
        require(mintOpen, "Minting is not open");
        _; 
    }

    constructor(address initialOwner)
        ERC1155("https://ipfs.io/ipfs/bafkreiewve5mn7rxion3i7i7olhoskt272oicurj4f6kiysh3hjtrpiqha")
        Ownable(initialOwner)
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function toggleMinting() public onlyOwner {
        mintOpen = !mintOpen;
    }

    function mint(address account)
        public
        canMint
    {
        _mint(account, nextId, 1, "");
        nextId = nextId + 1;
    }

    function mintBatch(address to, uint256 amount)
        public
        onlyOwner
    {

        // the array of ids should increment by 1 from nextId  to nextId + amount
        uint256[] memory ids = new uint256[](amount);
        for (uint256 i = 0; i < amount; i++) {
            ids[i] = nextId + i;
        }
        
        // amounts should all be 1
        uint256[] memory amounts = new uint256[](amount);
        for (uint256 i = 0; i < amount; i++) {
            amounts[i] = 1;
        }

        _mintBatch(to, ids, amounts, "");
        nextId = nextId + amount;
    }

    // this can be cheaper than batch minting and then transferring
    function airdrop(address[] memory recipients)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < recipients.length; i++) {
            mint(recipients[i]);
        }
    }

}