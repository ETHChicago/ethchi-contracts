// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Faucet.sol";
import "test/Wallet.sol";

// struct Wallet {
//     address addr;
//     uint256 publicKeyX;
//     uint256 publicKeyY;
//     uint256 privateKey;
// }

contract FaucetTest is Test {

    function test_ClaimTokens() public {
        Faucet faucet = new Faucet{value: 10 ether}();
        uint claimAmount = faucet.claimAmount();
        address payable user = payable(address(0x111));

        assertFalse(faucet.claimed(address(this)), "address has not yet claimed any ether");

        faucet.claimTokens{value: 0}(user);    

        assert(user.balance == claimAmount);
        assertTrue(faucet.claimed(address(this)), "user has claimed tokens");
    }

    function testFail_ClaimNotEnoughtFunds() public {
        Faucet faucet = new Faucet{value: 0}();
        address payable user = payable(address(0x112));

        faucet.claimTokens{value: 0}(user);
    }

    function testFail_DuplicateClaim() public {
        Faucet faucet = new Faucet{value: 10 ether}();
        address payable user = payable(address(0x113));

        faucet.claimTokens{value: 0}(user);
        faucet.claimTokens{value: 0}(user);
    }

    function test_SetOwner() public {
        Faucet faucet = new Faucet{value: 10 ether}();
        address payable user = payable(address(0x113));

        address owner = faucet.owner();
        assertTrue(owner == address(this), "test contract is initially owner");

        faucet.setOwner(user);
        owner = faucet.owner();
        assertTrue(owner == user, "other user should now be owner");
    }

    function testFail_SetOwnerNonOwner() public {
        Faucet faucet = new Faucet{value: 10 ether}();
        address payable user = payable(address(0x113));

        address owner = faucet.owner();
        assertTrue(owner == address(this), "test contract is initially owner");

        // call setOwner as other user 
        vm.startPrank(user);
        faucet.setOwner(user);
        vm.stopPrank();
    }

    function test_SetClaimAmount() public {
        Faucet faucet = new Faucet{value: 10 ether}();
        uint initialClaimAmount = faucet.claimAmount();
        uint newClaimAmount = 2 ether;

        assertFalse(initialClaimAmount == newClaimAmount, "claims amounts must be different");

        faucet.setClaimAmount(newClaimAmount);

        assertTrue(newClaimAmount == faucet.claimAmount(), "claim amount should be updated to the new amount");
    }

    function testFail_SetClaimAmountNonOwner() public {
        Faucet faucet = new Faucet{value: 10 ether}();
        uint initialClaimAmount = faucet.claimAmount();
        uint newClaimAmount = 2 ether;

        assertFalse(initialClaimAmount == newClaimAmount, "claims amounts must be different");


        address payable user = payable(address(0x114));
        vm.startPrank(user);
        faucet.setClaimAmount(newClaimAmount);
        vm.stopPrank();
    }

    function test_Donate() public {
        Faucet faucet = new Faucet{value: 10 ether}();
        faucet.donate{value: 1 ether}();
        assertTrue(address(faucet).balance == 11 ether);
    }

    function test_EmptyWallet() public {
        // Faucet faucet = new Faucet{value: 10 ether}();
        Wallet wallet = new Wallet();

        address payable user = payable(address(0x111));

        wallet.setWallet(user);

        assertTrue(wallet.getBalance(user) == 0);
        
        Faucet faucet = new Faucet{value: 10 ether}();
        faucet.claimTokens{value: 0}(user);

    }

}

// struct Wallet {
//     address addr;
//     uint256 publicKeyX;
//     uint256 publicKeyY;
//     uint256 privateKey;
// }