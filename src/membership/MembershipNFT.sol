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
    mapping(address => bool) public _kycVerified;

    // Current tokenId counter
    uint256 public _currentTokenId;
    
    // Desired price for membership
    uint256 public _price;

    // Metadata contract address
    address public _metadata;

    // Metadata contract interface
    IMetadata public _imetadata;

    constructor(
        string memory name_,
        string memory symbol_,
        address metadata_

    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        _name = name_;
        _symbol = symbol_;
        _currentTokenId = 0;
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

        require(msg.value >= _price, "Ether value sent is not correct");
        _currentTokenId++;
        _safeMint(msg.sender, _currentTokenId);
        _setTokenURI(_currentTokenId, _imetadata.getTokenURI(_currentTokenId));
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
    // @param user The address of the user to query the KYC status for
    // @return The KYC status as boolean
    function getKycStatus(address user) public view returns (bool) {
        return _kycVerified[user];
    }

    // Setter for KYC verification status
    // Only the owner of the contract can set the KYC status
    // @param user The address of the user to set the KYC status for
    // @param status The KYC status to set
    function setKycStatus(address user, bool status) public onlyOwner {
        _kycVerified[user] = status;
    }
}