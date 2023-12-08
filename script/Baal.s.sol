// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import '../src/Baal.sol';
import '../src/SharesERC20.sol';

contract BaalScript is Script {
    function setUp() public {}

    function run() public payable returns (address) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Baal baal = new Baal();
        vm.stopBroadcast();
        return address(baal);
    }
}
