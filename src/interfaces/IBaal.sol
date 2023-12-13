pragma solidity >=0.8.0;

interface IBaal {
    function mintShares(address[] calldata to, uint256[] calldata amount) external;
    function lootPaused() external returns (bool);
    function sharesPaused() external returns (bool);
}