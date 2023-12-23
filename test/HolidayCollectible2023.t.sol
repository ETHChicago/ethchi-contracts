// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/HolidayCollectible2023/HolidayCollectible2023.sol";

contract HolidayCollectible2023Test is Test {

    HolidayCollectible2023 public holidayCollectible;
    address public owner;
    address[] public mintRecipients;
    address public user1;

    function setUp() public {
        holidayCollectible = new HolidayCollectible2023(address(this));
        owner = address(this);
        user1 = address(0x1);

        // Set initial ownership to the contract itself
        holidayCollectible.transferOwnership(owner);
    }

    // Test that anybody should be able to mint if minting is open
    function test_openMinting() public {
        holidayCollectible.mint(user1);
        uint256 balance = holidayCollectible.balanceOf(user1, 0);
        assertEq(balance, 1);
    }

    // minting should increment nextId
    function test_nextId() public {
        assertEq(holidayCollectible.nextId(), 0);
        holidayCollectible.mint(user1);
        assertEq(holidayCollectible.nextId(), 1);
    }

    // Test that minting should not work if minting is not open
    function testFail_ClosedMinting() public {
        holidayCollectible.toggleMinting();
        holidayCollectible.mint(user1);
    }

    // Test that owner can mint batch for airdrop to a list of addresses
    function test_BatchMint() public {
        // nextid starts at 0
        assertEq(holidayCollectible.nextId(), 0);

        // mint 3 tokens
        holidayCollectible.mintBatch(user1, 3);

        // nextid should be 3
        assertEq(holidayCollectible.nextId(), 3);

        // check that user1 has 3 tokens
        uint256 balance0 = holidayCollectible.balanceOf(user1, 0);
        uint256 balance1 = holidayCollectible.balanceOf(user1, 1);
        uint256 balance2 = holidayCollectible.balanceOf(user1, 2);
        assertEq(balance0, 1);
        assertEq(balance1, 1);
        assertEq(balance2, 1);
    }

    // Test that owner can turn off minting 
    function test_OwnerToggleMinting() public {
        holidayCollectible.toggleMinting();
        assertEq(holidayCollectible.mintOpen(), false);
    }

    // Test that owner can change ownership 
    function test_OwnerChangeOwnership() public {
        holidayCollectible.transferOwnership(user1);
        assertEq(holidayCollectible.owner(), user1);
    }
}
