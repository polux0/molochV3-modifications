// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import '../src/LootERC20.sol';

contract LootERC20Script is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        LootERC20 lootERC20 = new LootERC20();
        vm.stopBroadcast();
    }
    // function setUp() public {

    // }
}
