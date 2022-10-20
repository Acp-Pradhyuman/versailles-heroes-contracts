//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT2 is ERC721URIStorage {
    //auto-increment field for each token
    // using Counters for Counters.Counter;

    // Counters.Counter private _tokenIds;

    address contractAddress;
    address public admin;
    bool public publicMintAllowed;

    constructor(address marketplaceAddress) ERC721("OpenSea Tokens", "OST") {
        contractAddress = marketplaceAddress;
        admin = msg.sender;
    }

    ///@notice only admin modifier
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can access this");
        _;
    }

    ///@notice only owner modifier
    modifier onlyOwner(uint256 tokenId) {
        require(msg.sender == ownerOf(tokenId));
        _;
    }

    /// @notice create a new token
    /// @param tokenUri : token URI
    function createToken(
        address _to,
        uint256 _tokenId,
        string memory tokenUri
    ) public returns (uint256) {
        require(publicMintAllowed || msg.sender == admin);

        _mint(_to, _tokenId); //mint the token to the box holder's address
        _setTokenURI(_tokenId, tokenUri); //generate the URI

        //return token ID
        return _tokenId;
    }

    // function setApprovalsForAll(
    //     address operator,
    //     bool approved,
    //     uint256 tokenId
    // ) public onlyOwner(tokenId) {
    //     setApprovalForAll(operator, approved);
    // }

    function setTokenURI(uint256 tokenId, string memory tokenUri)
        public
        onlyOwner(tokenId)
    {
        _setTokenURI(tokenId, tokenUri);
    }

    function burn(uint256 tokenId) public onlyOwner(tokenId) {
        _burn(tokenId);
    }

    function updateAdmin(address _admin) public onlyAdmin {
        admin = _admin;
    }

    function allowPublicMint() public onlyAdmin {
        publicMintAllowed = true;
    }
}
