// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import '../src/membership/MembershipNFT.sol';
import '../src/membership/Metadata.sol';

contract MembershipNFTScript is Script {

     string _name;
     string _symbol;

    function setUp() public {
        _name = "RobinHoodDAOMembership";
        _symbol = "RHDAOM";
    }

    function run() public returns (address) {
        uint256 deployerPrivateKey = vm.envUint("GOERLI_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Metadata _metadata = new Metadata();
        console.log('MembershipNFTMetadata deployed at: ', address(_metadata));
        MembershipNFT membershipERC721 = new MembershipNFT(_name, _symbol, address(_metadata));
        console.log('MembershipNFT deployed at: ', address(_metadata));
        vm.stopBroadcast();
        return address(membershipERC721);
    }
}