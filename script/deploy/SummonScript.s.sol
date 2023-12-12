// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import '../LootERC20.s.sol';
import '../SharesERC20.s.sol';
import '../Baal.s.sol';

import '../../src/BaalSummoner.sol';
import '../../src/Baal.sol';

import '../../src/interfaces/IBaal.sol';


contract SummonScript is Script {

    LootERC20Script lootScript;
    SharesERC20Script sharesScript;
    BaalScript baalScript;
    Baal baal;
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

    // governance config

    uint256 VOTING_PERIOD_IN_SECONDS = 100;
    uint256 GRACE_PERIOD_IN_SECONDS = 100;
    uint256 PROPOSAL_OFFERING = 1;
    uint256 QUORUM_PERCENT = 10;
    uint256 SPONSOR_THRESHOLD = 1;
    uint256 MIN_RETENTION_PERCENT= 1;

    // baal singleton;

    address payable baalSingletonAddress;

    // deployment config

    uint256 MIN_STAKING_PERCENT = 0;
    string TOKEN_NAME = "Baal Shares";
    string TOKEN_SYMBOL = "BS";

    // metadata config

    string content = '{"name":"test proposal"}';
    string tag = "initial proposal metadata";

    // shares paused

    bool sharesPaused = false;
    bool lootPaused = false;

    // shamans

    address[] shamans = ['0x70997970C51812dc3A010C7d01b50e0d17dc79C8'];
    uint256[] permissions = [7];

    // summoner array
    address summoners = ['0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'];
    uint256 summonersShares = [10];

    // shares array
    uint256 summonersLoot = [10];

    // adming config 
    bool transferableTokens = [false,false];

    bytes governanceConfig;
    bytes deploymentConfig;
    bytes adminConfig;


    function getGovernanceConfig() public view returns (bytes memory) {
        return abi.encode(
            VOTING_PERIOD_IN_SECONDS,
            GRACE_PERIOD_IN_SECONDS,
            PROPOSAL_OFFERING,
            QUORUM_PERCENT,
            SPONSOR_THRESHOLD,
            MIN_RETENTION_PERCENT
        );
    }

    function getDeploymentConfig() public view returns (bytes memory) {
        return abi.encode(
            GRACE_PERIOD_IN_SECONDS,
            VOTING_PERIOD_IN_SECONDS,
            PROPOSAL_OFFERING,
            SPONSOR_THRESHOLD,
            SPONSOR_THRESHOLD,
            MIN_RETENTION_PERCENT,
            MIN_STAKING_PERCENT,
            QUORUM_PERCENT,
            TOKEN_NAME,
            TOKEN_SYMBOL
        );
    }
    function getAdminConfig() public view returns (bytes memory) {
        return abi.encode(transferableTokens);
    }

    // encode actions

    function encodeSetAdminConfig(bool pauseShares, bool pauseLoot) public view returns (bytes memory) {
        return abi.encodeWithSignature("setAdminConfig(bool,bool)", pauseShares, pauseLoot);
    }
    function encodeSetGovernanceConfig(bytes memory _governanceConfig) public view returns (bytes memory) {
        return abi.encodeWithSignature("setGovernanceConfig(bytes)", _governanceConfig);
    }
    function encodeSetShamans(address[] memory _shamans, uint256[] memory _permissions) public view returns (bytes memory){
        require(_shamans.length == _permissions.length, "!array parity"); // Ensuring array lengths match
        return abi.encodeWithSignature("setShamans(address[],uint256[])", _shamans, _permissions);
    }
    function encodeMintShares(address[] to, uint256[] amount) public {
        require(to.length == amount.length, "!array parity");
        return abi.encodeWithSignature("mintShares(address[], uint256[])", to, amount);
    }
    function encodeMintLoot(address[] to, uint256[] amount) public {
        require(to.length == amount.length, "!array parity");
        return abi.encodeWithSignature("mintShares(address[], uint256[])", to, amount);
    }
    function encodePost(string _content, string _tag) public {
        return abi.encodeWithSignature("post(string,string)", _content, _tag);
    }
    function encodeExecuteAsBaal(address _to, uint256 _value, bytes calldata _data) public {
        return abi.encodeWithSignature("executeAsBaal(address,uint256,bytes)", _to, _value, encodePost(content, tag));
    }
    function encodeInitParams() public {
        return abi.encode(TOKEN_NAME, TOKEN_SYMBOL);
    }
    function encodeInitActions() public {
        return abi.encode(encodeSetAdminConfig(), encodeSetGovernanceConfig(), encodeSetShamans(), encodeMintShares(), encodeMintLoot(), encodeExecuteAsBaal());
    }

    function setUp() public {
        

        lootScript = new LootERC20Script();
        sharesScript = new SharesERC20Script();
        baalScript = new BaalScript();

        adminConfig = getAdminConfig();
        governanceConfig = getGovernanceConfig();

    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address lootERC20SingletonAddress = lootScript.run();
        console.log('LootERC20Singleton deployed at: ', lootERC20SingletonAddress);
        address sharesERC20SingletonAddress = sharesScript.run();
        console.log('SharesERC20Signleton deployed at: ', sharesERC20SingletonAddress);
        baalSingletonAddress = payable(baalScript.run());
        console.log('BaalSingleton deployed at: ', baalSingletonAddress);
        vm.startBroadcast(deployerPrivateKey);
        baalSummoner = new BaalSummoner(baalSingletonAddress, gnosisSingleton, gnosisFallbackLibrary, gnosisMultisendLibrary, gnosisSafeProxyFactory, moduleProxyFactory, lootERC20SingletonAddress, sharesERC20SingletonAddress);
        console.log('BaalSummoner deployed at: ', address(baalSummoner));
        vm.stopBroadcast();
        baal = new Baal();

        // encoded init params
        bytes memory encodedInitParams = encodeInitParams();
        // encoded init actions
        bytes memory encodedInitActions = encodeInitActions();

        uint256 randomSeed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10000000;

        baalSummoner.summonBaalAndSafe(
        encodedInitParams.initParams,
        encodedInitParams.initalizationActions,
        randomSeed
        );

    }
    // function setUp() public {

    // }
}
