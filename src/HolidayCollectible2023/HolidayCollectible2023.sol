// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract HolidayCollectible2023 is ERC721 {
    uint256 private _nextTokenId;

    constructor()
        ERC721("ETHChi Immutable Spirit", "ETHCHI_XMAS_2023")
    {}

    function safeMint() public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function contractURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/bafkreiewve5mn7rxion3i7i7olhoskt272oicurj4f6kiysh3hjtrpiqha";
    }

    function tokenURI(uint256 tokenId) public pure override returns (string memory) {
        return contractURI();
    }

}