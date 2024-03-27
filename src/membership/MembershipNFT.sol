pragma solidity >=0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; // OZ: Ownable
import "@openzeppelin/contracts/utils/Strings.sol"; // OZ: Strings
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // OZ: ERC721URIStorage 
import '../interfaces/IMetadata.sol';
//SPDX-License-Identifier: MIT

/// @title MembershipNFT
/// @notice Accounting for members that are light KYC verified as well as for those that are not
contract MembershipNFT is IERC721Receiver, ERC721URIStorage, Ownable{
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Is member kyc verified
    mapping(uint256 => bool) public _kycVerified;

    // Current tokenId counter
    uint256 public _currentTokenId;
    
    // Desired price for membership
    uint256 public _price;

    // Metadata contract address
    address public _metadata;

    // Metadata contract interface
    IMetadata public _imetadata;

    // Event for when a member is KYC verified
    event MembershipVerified(uint256 indexed tokenId, bool status);

    // Event for a when membership is minted
    event MembershipMinted(uint256 indexed tokenId);

    constructor(
        string memory name_,
        string memory symbol_,
        address metadata_

    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        _name = name_;
        _symbol = symbol_;
        _currentTokenId = 0;
        _price = 0.00000000000001 ether;
        _imetadata = IMetadata(metadata_);

    }

    // not quite sure how to design it at the moment, so we'll leave it as technical debt at the moment
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {}
    
    // mint an nft
    function mint() public payable {
        // require(msg.value >= _price, "Ether value sent is not correct");
        _currentTokenId++;
        _safeMint(msg.sender, _currentTokenId);
        _setTokenURI(_currentTokenId, _imetadata.getTokenURI(_currentTokenId));
        emit MembershipMinted(_currentTokenId);
    }
    // set price for the membership, owner only
    function setPrice(uint256 newPrice) public onlyOwner(){
        // Here you can add access control to restrict who can call this function
        _price = newPrice;
    }

    // get price for the membership
    function getPrice() public view returns (uint256) {
        return _price;
    }
    // Getter for KYC verification status
    // @param nftId The id of the nft to query the KYC status for
    // @return The KYC status as boolean
    function getKycStatus(uint256 nftId) public view returns (bool) {
        return _kycVerified[nftId];
    }

    // Setter for KYC verification status
    // Only the owner of the contract can set the KYC status
    // @param nftId The id of the nft to set the KYC status for
    // @param status The KYC status to set
    function setKycStatus(uint256 nftId, bool status) public onlyOwner {
        _kycVerified[nftId] = status;
    }
    // technical debt
    function setKycStatusMultiple(uint256[] memory nftIds, bool status) public {
    for (uint i = 0; i < nftIds.length; i++) {
        _kycVerified[nftIds[i]] = status;
        emit MembershipVerified(nftIds[i], status);
    }
}
    // technical debt
    // create modifier `shamanOnly`
}