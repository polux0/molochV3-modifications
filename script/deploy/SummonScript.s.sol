// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import '../LootERC20.s.sol';
import '../SharesERC20.s.sol';
import '../Baal.s.sol';

import '../../src/BaalSummoner.sol';

// import '../../src/SharesERC20.sol';
// import '../../src/LootERC20.sol';
// import '../../src/Baal.sol';


contract SummonScript is Script {

    LootERC20Script lootScript;
    SharesERC20Script sharesScript;
    BaalScript baalScript;
    BaalSummoner baalSummoner;

    struct Addresses {
        address gnosisSingleton;
        address gnosisFallbackLibrary;
        address gnosisMultisendLibrary;
        address poster;
        address gnosisSafeProxyFactory;
        address moduleProxyFactory;
    }

    Addresses addresses; 
    address gnosisSingleton = 0xd9Db270c1B5E3Bd161E8c8503c55cEABeE709552;
    address gnosisFallbackLibrary = 0xf48f2B2d2a534e402487b3ee7C18c33Aec0Fe5e4;
    address gnosisMultisendLibrary = 0xA238CBeb142c10Ef7Ad8442C6D1f9E89e07e7761;
    address poster = 0x000000000000cd17345801aa8147b8D3950260FF;
    address gnosisSafeProxyFactory = 0xa6B71E26C5e0845f74c812102Ca7114b6a896AB2;
    address moduleProxyFactory = 0x00000000062c52e29e8029Dc2413172f6D619d85; 

    function setUp() public {
        
        lootScript = new LootERC20Script();
        sharesScript = new SharesERC20Script();
        baalScript = new BaalScript();
     
        // if we modify Baal summoner's constructor to accept struct, this would be optimal
        // addresses = Addresses({
        //     gnosisSingleton: 0xd9Db270c1B5E3Bd161E8c8503c55cEABeE709552,
        //     gnosisFallbackLibrary: 0xf48f2B2d2a534e402487b3ee7C18c33Aec0Fe5e4,
        //     gnosisMultisendLibrary: 0xA238CBeb142c10Ef7Ad8442C6D1f9E89e07e7761,
        //     poster: 0x000000000000cd17345801aa8147b8D3950260FF,
        //     gnosisSafeProxyFactory: 0xa6B71E26C5e0845f74c812102Ca7114b6a896AB2,
        //     moduleProxyFactory: 0x270c012B6C2A61153e8A6d82F2Cb4F88ddB7fD5E
        // });

    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address lootERC20SingletonAddress = lootScript.run();
        console.log('LootERC20Singleton deployed at: ', lootERC20SingletonAddress);
        address sharesERC20SingletonAddress = sharesScript.run();
        console.log('SharesERC20Signleton deployed at: ', sharesERC20SingletonAddress);
        address payable baalSingletonAddress = payable(baalScript.run());
        console.log('BaalSingleton deployed at: ', baalSingletonAddress);
        vm.startBroadcast(deployerPrivateKey);
        baalSummoner = new BaalSummoner(baalSingletonAddress, gnosisSingleton, gnosisFallbackLibrary, gnosisMultisendLibrary, gnosisSafeProxyFactory, moduleProxyFactory, lootERC20SingletonAddress, sharesERC20SingletonAddress);
        console.log('BaalSummoner deployed at: ', address(baalSummoner));
        vm.stopBroadcast();

    }
    // function setUp() public {

    // }
}
