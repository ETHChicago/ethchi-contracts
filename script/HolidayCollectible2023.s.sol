// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/HolidayCollectible2023/HolidayCollectible2023.sol";

contract HolidayCollectible2023Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        HolidayCollectible2023 holidayCollectible2023 = new HolidayCollectible2023();

        vm.stopBroadcast();
    }
}