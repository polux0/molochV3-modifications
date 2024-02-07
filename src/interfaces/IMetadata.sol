// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

/// @title IMetadata
/// @notice Interface for Metadata contract
interface IMetadata {
    /// @notice Returns the token URI for a given token ID
    /// @param tokenId The token ID to query the URI for
    /// @return The token URI string
    function getTokenURI(uint256 tokenId) external view returns (string memory);
}