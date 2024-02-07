pragma solidity >=0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol"; // OZ: Ownable
import "@openzeppelin/contracts/utils/Strings.sol"; // OZ: Strings
import "@openzeppelin/contracts/utils/Base64.sol"; // OZ: Base64
import '../interfaces/IMetadata.sol';

//SPDX-License-Identifier: MIT

/// @title MembershipNFT metadata
/// @notice Constructs necessary metadata for MembershipNFT
contract Metadata is IMetadata, Ownable{
    using Strings for uint256;
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Is member kyc verified
    string private _kycVerified;

    // Current tokenId counter
    uint256 public _currentTokenId;
    
    // Desired price for membership
    uint256 public _price;

    constructor() Ownable(msg.sender) {
    }

    function getTokenURI(uint256 tokenId) public pure returns (string memory) {
        string memory name = string(abi.encodePacked('RobinHood DAO membership #', tokenId.toString()));
        
        // string memory description = storageFacadeManager.getUnitStorageFacade().getUnitBasedOnId(tokenId);
        string memory description = "Simple description";

        // string memory imageURL = "ipfs://QmW6XNWUcc6xc28UW5yVcSAsujzidgJ8hR9ML3SbMzbfaM/";
        // string memory image = string(abi.encodePacked(imageURL1, Strings.toString(tokenId), ".png"));

        string memory imageURL = "ipfs://QmW6XNWUcc6xc28UW5yVcSAsujzidgJ8hR9ML3SbMzbfaM/";
        string memory image = string(abi.encodePacked(imageURL, Strings.toString(tokenId), ".png"));

        // string[] memory traitValues = new string[](TRAIT_TYPES.length);
        // for (uint256 i = 0; i < TRAIT_TYPES.length; i++) {
        //     traitValues[i] = getTraitValue(i, tokenId);
        // }

        // string memory attributes = buildAttributes(TRAIT_TYPES, traitValues);
        // string memory metadata = encodeMetadata(name, description, image, attributes);

        // string memory attributes = buildAttributes(TRAIT_TYPES, traitValues);
        string memory metadata = encodeMetadata(name, description, image);
        return metadata;
    }
    // Encode metadata as Base64 encoded string
    function encodeMetadata(
        string memory name,
        string memory description,
        string memory image
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"name":"',
                            name,
                            '","description":"',
                            description,
                            '","image":"',
                            image,
                            '}'
                        )
                    )
                )
            );
    }

}