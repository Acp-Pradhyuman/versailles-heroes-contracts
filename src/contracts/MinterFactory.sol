// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IMintableERC721 is IERC721 {
    function mint(address to, uint256 tokenId) external;
}

contract MinterFactory is Ownable, Initializable {
    // NFT contract
    IMintableERC721 public erc721;
    bool public publicMintAllowed;

    event TokenMinted(
        address contractAddress,
        address to,
        uint256 indexed tokenId
    );

    function init(address _erc721) external initializer onlyOwner {
        erc721 = IMintableERC721(_erc721);
    }

    /**
     * @dev mint function to distribute thetan NFT to user
     */
    function mintTo(address to, uint256 tokenId) external {
        require(publicMintAllowed || _msgSender() == owner());
        erc721.mint(to, tokenId);
        emit TokenMinted(address(erc721), to, tokenId);
    }

    /**
     * @dev function to allow user mint items
     */
    function allowPublicMint() public onlyOwner {
        publicMintAllowed = true;
    }
}
