// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import '../src/SharesERC20.sol';

contract SharesERC20Script is Script {

    function setUp() public {
    }

    function run() public returns (address){
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        SharesERC20 sharesERC20 = new SharesERC20();
        vm.stopBroadcast();
        return address(sharesERC20);
    }
}
