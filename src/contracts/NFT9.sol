//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma abicoder v2; // required to accept structs as function parameters

// import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Auctions.sol";

contract NFT9 is ERC721URIStorage, EIP712, Auction {
    //auto-increment field for each token
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    address payable public admin;
    uint256 public platformCommission;

    // Counters.Counter private _tokenIds;

    // address contractAddress;

    // bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    string private constant SIGNING_DOMAIN = "LazyNFT-Voucher";
    string private constant SIGNATURE_VERSION = "1";

    constructor()
        ERC721("OpenSea Tokens", "OST")
        EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION)
    {
        admin = payable(msg.sender);
        platformCommission = 2;
        //_setupRole(MINTER_ROLE, minter);
    }

    ///@notice only owner modifier
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can access this");
        _;
    }

    ///@notice only owner modifier
    modifier onlyOwner(uint256 tokenId) {
        require(msg.sender == ownerOf(tokenId));
        _;
    }

    // constructor(address marketplaceAddress) ERC721("OpenSea Tokens", "OST") {
    // contractAddress = marketplaceAddress;
    // }

    struct NFTVoucher {
        /// @notice The id of the token to be redeemed. Must be unique - if another token with this ID already exists, the redeem function will revert.
        uint256 tokenId;
        /// @notice The minimum price (in wei) that the NFT creator is willing to accept for the initial sale of this NFT.
        uint256 minPrice;
        /// @notice The metadata URI to associate with this token.
        string uri;
        /// @notice the EIP-712 signature of all other fields in the NFTVoucher struct. For a voucher to be valid, it must be signed by an account with the MINTER_ROLE.
        bytes signature;
    }

    struct MarketItem {
        uint256 marketItemId;
        uint256 tokenId;
        uint256 royalty;
        address payable creator;
        address payable seller;
        address payable owner;
        IERC20 token;
    }

    event MarketItemCreated(
        uint256 indexed marketItemId,
        uint256 indexed tokenId,
        uint256 price,
        uint256 royalty,
        address creator,
        address seller,
        address owner
    );

    event MarketItemResell(
        uint256 indexed marketItemId,
        address seller,
        address owner,
        uint256 price
    );

    mapping(uint256 => MarketItem) public allMarketItems;

    function updatePlatformCommision(uint256 _platformCommission)
        public
        onlyAdmin
    {
        platformCommission = _platformCommission;
    }

    function updateAdmin(address _admin) public onlyAdmin {
        admin = payable(_admin);
    }

    // function setupRole(address payable minter) public onlyAdmin {
    // _setupRole(MINTER_ROLE, minter);
    // }

    /// @notice create a new token
    /// @param voucher : contains details of tokenId, price, uri and signature
    function createAndBuyToken(NFTVoucher calldata voucher, uint256 _royalty)
        public
        payable
        returns (uint256)
    {
        address signer = _verify(voucher); //her signer is the seller

        // require(
        // hasRole(MINTER_ROLE, signer),
        // "Signature invalid or unauthorized"
        // );
        require(msg.sender != signer, "Sellers can't buy from marketplace");
        // require(msg.value == _price, "Must submit asking price to purchase");
        require(
            msg.value >= voucher.minPrice,
            "Must submit atleast the min price to purchase"
        );
        //set a new token id for the token to be minted
        // _tokenIds.increment();
        // uint256 newItemId = _tokenIds.current();

        _itemIds.increment(); //incrementing our counter.
        uint256 marketItemId = _itemIds.current(); //storing current value of counter in a new local variable.

        //Initializing the structure MarketItem, and saving it in allMarketItems mapping with our local variable passed as an argument.
        allMarketItems[marketItemId] = MarketItem(
            marketItemId,
            voucher.tokenId,
            _royalty,
            payable(signer), //Only creator will be able to create items to sell.
            payable(signer), //Marketplace is the seller when market item is first created.
            payable(msg.sender), //setting the owner's address to zero, as it still need to be sold on marketplace.
            IERC20(address(0))
        );

        _mint(signer, voucher.tokenId); //mint the token
        _setTokenURI(voucher.tokenId, voucher.uri); //generate the URI
        // setApprovalForAll(address(this), true); //grant transaction permission to marketplace
        // IERC721(address(this)).transferFrom(seller, address(this), _tokenId);

        _transfer(signer, msg.sender, voucher.tokenId);
        _transferBuy(msg.value, marketItemId, msg.sender);

        // buyMarketItem721(marketItemId, msg.value);

        emit MarketItemCreated(
            marketItemId,
            voucher.tokenId,
            voucher.minPrice,
            _royalty,
            signer,
            signer,
            msg.sender
        );

        //return token ID
        return voucher.tokenId;
    }

    function createAndBuyTokenWETH(
        NFTVoucher calldata voucher,
        uint256 _royalty,
        IERC20 _token
    ) public payable returns (uint256) {
        address signer = _verify(voucher); //her signer is the seller

        // require(
        // hasRole(MINTER_ROLE, signer),
        // "Signature invalid or unauthorized"
        // );
        require(msg.sender != signer, "Sellers can't buy from marketplace");
        // require(msg.value == _price, "Must submit asking price to purchase");
        //set a new token id for the token to be minted
        // _tokenIds.increment();
        // uint256 newItemId = _tokenIds.current();

        _itemIds.increment(); //incrementing our counter.
        uint256 marketItemId = _itemIds.current(); //storing current value of counter in a new local variable.

        //Initializing the structure MarketItem, and saving it in allMarketItems mapping with our local variable passed as an argument.
        allMarketItems[marketItemId] = MarketItem(
            marketItemId,
            voucher.tokenId,
            _royalty,
            payable(signer), //Only creator will be able to create items to sell.
            payable(signer), //Marketplace is the seller when market item is first created.
            payable(msg.sender), //setting the owner's address to zero, as it still need to be sold on marketplace.
            _token
        );

        _mint(signer, voucher.tokenId); //mint the token
        _setTokenURI(voucher.tokenId, voucher.uri); //generate the URI
        // setApprovalForAll(address(this), true); //grant transaction permission to marketplace
        // IERC721(address(this)).transferFrom(seller, address(this), _tokenId);

        _transfer(signer, msg.sender, voucher.tokenId);
        _transferBuy(voucher.minPrice, marketItemId, msg.sender);

        // buyMarketItem721(marketItemId, msg.value);

        emit MarketItemCreated(
            marketItemId,
            voucher.tokenId,
            voucher.minPrice,
            _royalty,
            signer,
            signer,
            msg.sender
        );

        //return token ID
        return voucher.tokenId;
    }

    function _transferBuy(
        uint256 _amount,
        uint256 _marketItemId,
        address _recipient
    ) internal {
        uint256 sellingPrice = _amount;

        uint256 commission = (platformCommission * sellingPrice) / 100;

        uint256 sellerShare = ((100 - platformCommission) * sellingPrice) / 100;

        if (allMarketItems[_marketItemId].token == IERC20(address(0))) {
            admin.transfer(commission); //Transfering the listing fee to the admin of the marketplace.
            allMarketItems[_marketItemId].seller.transfer(sellerShare); //transferring the sale amount to the seller after deducting platform commission.
        } else {
            IERC20 token = allMarketItems[_marketItemId].token;
            token.transferFrom(_recipient, address(this), sellingPrice);
            token.transfer(admin, commission);
            token.transfer(allMarketItems[_marketItemId].seller, sellerShare);
        }
    }

    function secondaryBuyToken(
        uint256 _marketItemId,
        NFTVoucher calldata voucher
    ) public payable {
        address signer = _verify(voucher);
        require(msg.sender != signer, "Sellers can't buy from marketplace");
        require(
            signer == allMarketItems[_marketItemId].owner,
            "Only owner can transfer the NFT"
        );
        require(
            allMarketItems[_marketItemId].tokenId == voucher.tokenId,
            "Voucher's tokenId and marketitem's tokenId are not matching"
        );
        require(
            msg.value >= voucher.minPrice,
            "Must submit atleast the min price to purchase"
        );

        allMarketItems[_marketItemId].seller = payable(signer);
        allMarketItems[_marketItemId].owner = payable(msg.sender);

        _transfer(signer, msg.sender, allMarketItems[_marketItemId].tokenId);
        _transferSecondaryBuy(msg.value, _marketItemId, msg.sender);

        emit MarketItemResell(
            _marketItemId,
            signer,
            msg.sender,
            voucher.minPrice
        );
    }

    function secondaryBuyTokenWETH(
        uint256 _marketItemId,
        NFTVoucher calldata voucher
    ) public payable {
        address signer = _verify(voucher);
        require(msg.sender != signer, "Sellers can't buy from marketplace");
        require(
            signer == allMarketItems[_marketItemId].owner,
            "Only owner can transfer the NFT"
        );
        require(
            allMarketItems[_marketItemId].tokenId == voucher.tokenId,
            "Voucher's tokenId and marketitem's tokenId are not matching"
        );
        // require(
        // msg.value >= voucher.minPrice,
        // "Must submit atleast the min price to purchase"
        // );

        allMarketItems[_marketItemId].seller = payable(signer);
        allMarketItems[_marketItemId].owner = payable(msg.sender);

        _transfer(signer, msg.sender, allMarketItems[_marketItemId].tokenId);
        _transferSecondaryBuy(voucher.minPrice, _marketItemId, msg.sender);

        emit MarketItemResell(
            _marketItemId,
            signer,
            msg.sender,
            voucher.minPrice
        );
    }

    function _transferSecondaryBuy(
        uint256 _amount,
        uint256 _marketItemId,
        address _recipient
    ) internal {
        uint256 royalty = (allMarketItems[_marketItemId].royalty * _amount) /
            100;

        uint256 transferAfterRoyalty = ((100 -
            allMarketItems[_marketItemId].royalty) * _amount) / 100;

        // address _to = msg.sender;

        if (allMarketItems[_marketItemId].token == IERC20(address(0))) {
            allMarketItems[_marketItemId].creator.transfer(royalty); //Sending royalty to the creator.
            allMarketItems[_marketItemId].seller.transfer(transferAfterRoyalty); //Sending royalty to the creator.
        } else {
            IERC20 token = allMarketItems[_marketItemId].token;
            token.transferFrom(_recipient, address(this), _amount);
            token.transfer(allMarketItems[_marketItemId].creator, royalty);
            token.transfer(
                allMarketItems[_marketItemId].seller,
                transferAfterRoyalty
            );
        }
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI)
        public
        onlyOwner(tokenId)
    {
        setTokenURI(tokenId, _tokenURI);
    }

    function burn(uint256 tokenId) public onlyOwner(tokenId) {
        _burn(tokenId);
    }

    function _hash(NFTVoucher calldata voucher)
        internal
        view
        returns (bytes32)
    {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256(
                            "NFTVoucher(uint256 tokenId,uint256 minPrice,string uri)"
                        ),
                        voucher.tokenId,
                        voucher.minPrice,
                        keccak256(bytes(voucher.uri))
                    )
                )
            );
    }

    function getChainID() external view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    function _verify(NFTVoucher calldata voucher)
        internal
        view
        returns (address)
    {
        bytes32 digest = _hash(voucher);
        return ECDSA.recover(digest, voucher.signature);
    }

    // function supportsInterface(bytes4 interfaceId)
    //     public
    //     view
    //     virtual
    //     // override(AccessControl, ERC721)
    //     returns (bool)
    // {
    //     return
    //         ERC721.supportsInterface(interfaceId) ||
    //         AccessControl.supportsInterface(interfaceId);
    // }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///auction///
    /////////////////////////////////////////////////////////////////////////////////////////////////////////

    function startAuction(
        uint256 _nftId,
        uint256 startingBid,
        uint256 auctionPeriodInDays,
        address _token
    ) external {
        start(_nftId, startingBid, auctionPeriodInDays, _token, msg.sender);
    }

    function placeBid(uint256 _nftId, uint256 amount) external payable {
        bid(_nftId, amount, msg.sender, msg.value);
    }

    function endAuction(NFTVoucher calldata voucher, address bidder) external {
        address signer = _verify(voucher);
        require(seller[voucher.tokenId] == signer, "Invalid signature");
        require(signer == msg.sender, "Only a creator can end the auction");

        end(voucher.tokenId, bidder, signer, platformCommission, admin);

        /////////////////////////////////////////////////////////////
        _mint(signer, voucher.tokenId); //mint the token
        _setTokenURI(voucher.tokenId, voucher.uri); //generate the URI

        if (bidder != address(0)) {
            _transfer(signer, bidder, voucher.tokenId);
        } else {
            _transfer(signer, highestBidder[voucher.tokenId], voucher.tokenId);
        }
    }

    function withdrawBid(uint256 _nftId) external {
        withdraw(_nftId);
    }
}
