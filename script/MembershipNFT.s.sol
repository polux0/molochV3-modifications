// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import '../src/membership/MembershipNFT.sol';

contract MembershipNFTScript is Script {

     string _name;
     string _symbol;

    function setUp() public {
        _name = "RobinHoodDAOMembership";
        _symbol = "RHDAOM";
    }

    function run() public returns (address) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        MembershipNFT membershipERC721 = new MembershipNFT(_name, _symbol);
        vm.stopBroadcast();
        return address(membershipERC721);
    }
}