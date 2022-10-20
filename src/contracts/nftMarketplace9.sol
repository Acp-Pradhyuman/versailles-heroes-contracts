//SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract nftMarketplace9 is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    address public admin;
    address[] public creators;
    mapping(address => bool) public isCreator;
    uint256 public platformCommission;

    constructor() {
        admin = msg.sender;
        platformCommission = 2;
    }

    // [ MODIFIERS ]

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can access this");
        _;
    }

    //This will hold data of each nft available on the marketplace.
    struct MarketItem {
        uint256 marketItemId;
        uint256 tokenId;
        uint256 price;
        // uint256 royalty;
        // address payable creator;
        address seller;
        address owner;
        address nftContract;
        bool sold;
    }

    //a mapping to point to our structure marketItem. It will take marketItemId as an input.
    // mapping(uint256 => MarketItem) private allMarketItems;
    mapping(uint256 => MarketItem) public allMarketItems;

    event MarketItemCreated(
        uint256 indexed marketItemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        // uint256 royalty,
        uint256 price,
        bool sold
    );

    // [ ADMIN FUNCTIONS ]

    // Fallback: reverts if Ether is sent to this smart contract by mistake
    // fallback() external {
    //     revert();
    // }

    function updatePlatformCommision(uint256 _platformCommission)
        public
        onlyAdmin
    {
        platformCommission = _platformCommission;
    }

    function updateAdmin(address _admin) public onlyAdmin {
        admin = _admin;
    }

    // [ TRADE FUNCTIONS ]
    //For listing an item on the marketplace.
    //onlyCreator
    // //ERC 721
    // function createMarketItem721(
    //     address _nftContract,
    //     uint256 _tokenId,
    //     uint256 _price,
    //     uint256 _royalty
    // ) public payable nonReentrant {
    //     require(_price > 0, "Listing price must be greater than zero.");
    //     // require(
    //     //     _price > platformCommission,
    //     //     "Minimum platform commission is not met."
    //     // );

    //     _itemIds.increment(); //incrementing our counter.
    //     uint256 marketItemId = _itemIds.current(); //storing current value of counter in a new local variable.

    //     //Initializing the structure MarketItem, and saving it in allMarketItems mapping with our local variable passed as an argument.
    //     allMarketItems[marketItemId] = MarketItem(
    //         marketItemId,
    //         _tokenId,
    //         1,
    //         _price,
    //         _royalty,
    //         payable(msg.sender), //Only creator will be able to create items to sell.
    //         payable(msg.sender), //Marketplace is the seller when market item is first created.
    //         payable(address(0)), //setting the owner's address to zero, as it still need to be sold on marketplace.
    //         _nftContract,
    //         IERC20(address(0))
    //     );

    //     IERC721(_nftContract).transferFrom(msg.sender, address(this), _tokenId); //Transfering NFT from creator to marketplace.

    //     emit MarketItemCreated(
    //         marketItemId,
    //         _nftContract,
    //         _tokenId,
    //         msg.sender,
    //         _royalty,
    //         _price
    //     );
    // }

    // //ERC 1155
    // function createMarketItem1155(
    //     address _nftContract,
    //     uint256 _tokenId,
    //     uint256 _amount,
    //     uint256 _price,
    //     uint256 _royalty
    // ) public payable nonReentrant {
    //     require(_price > 0, "Listing price must be greater than zero.");
    //     // require(
    //     //     _price > platformCommission,
    //     //     "Minimum platform commission is not met."
    //     // );

    //     _itemIds.increment(); //incrementing our counter.
    //     uint256 marketItemId = _itemIds.current(); //storing current value of counter in a new local variable.

    //     //Initializing the structure MarketItem, and saving it in allMarketItems mapping with our local variable passed as an argument.
    //     allMarketItems[marketItemId] = MarketItem(
    //         marketItemId,
    //         _tokenId,
    //         _amount,
    //         _price,
    //         _royalty,
    //         payable(msg.sender), //Only creator will be able to create items to sell.
    //         payable(msg.sender), //Marketplace is the seller when market item is first created.
    //         payable(address(0)), //setting the owner's address to zero, as it still need to be sold on marketplace.
    //         _nftContract,
    //         IERC20(address(0))
    //     );

    //     IERC1155(_nftContract).safeTransferFrom(
    //         msg.sender,
    //         address(this),
    //         _tokenId,
    //         _amount,
    //         ""
    //     ); //Transfering NFT from creator to marketplace.

    //     emit MarketItemCreated(
    //         marketItemId,
    //         _nftContract,
    //         _tokenId,
    //         msg.sender,
    //         _royalty,
    //         _price
    //     );
    // }

    //ERC721
    function createMarketItem721WETH(
        address _nftContract,
        uint256 _tokenId,
        uint256 _price
    )
        public
        // uint256 _royalty
        nonReentrant
    {
        require(_price > 0, "Listing price must be greater than zero.");
        // require(
        //     _price > platformCommission,
        //     "Minimum platform commission is not met."
        // );

        _itemIds.increment(); //incrementing our counter.
        uint256 marketItemId = _itemIds.current(); //storing current value of counter in a new local variable.

        //Initializing the structure MarketItem, and saving it in allMarketItems mapping with our local variable passed as an argument.
        allMarketItems[marketItemId] = MarketItem(
            marketItemId,
            _tokenId,
            _price,
            // _royalty,
            // payable(msg.sender), //Only creator will be able to create items to sell.
            msg.sender, //Marketplace is the seller when market item is first created.
            address(0), //setting the owner's address to zero, as it still need to be sold on marketplace.
            _nftContract,
            false
        );

        IERC721(_nftContract).transferFrom(msg.sender, address(this), _tokenId); //Transfering NFT from creator to marketplace.

        emit MarketItemCreated(
            marketItemId,
            _nftContract,
            _tokenId,
            msg.sender,
            // _royalty,
            _price,
            false
        );
    }

    //For sellers, To remove created NFT market item. Only sellers can call this function.
    //ERC 721
    function removeMarketItem721WETH(
        address _nftContract,
        uint256 _marketItemId
    ) public nonReentrant {
        // require(
        //     msg.sender == allMarketItems[_marketItemId].creator,
        //     "A Creator is not allowed to remove the market item"
        // );
        require(
            msg.sender == allMarketItems[_marketItemId].seller,
            "Only a seller is allowed to remove the market item"
        );
        require(
            allMarketItems[_marketItemId].owner == address(0),
            "item already sold out"
        );
        require(
            allMarketItems[_marketItemId].sold != true,
            "item already sold out"
        );

        allMarketItems[_marketItemId].owner = msg.sender;
        // allMarketItems[_marketItemId].price = 0;

        uint256 tokenId = allMarketItems[_marketItemId].tokenId;
        IERC721(_nftContract).transferFrom(address(this), msg.sender, tokenId); //sending the NFT back to the seller.
        // delete allMarketItems[_marketItemId];
    }

    //For sellers, To update price and resell created NFT market item. Only sellers can call this function.
    //ERC 721
    function updateMarketItem721WETH(
        address _nftContract,
        uint256 _marketItemId,
        uint256 _price
    ) public nonReentrant {
        require(msg.sender == allMarketItems[_marketItemId].seller);
        require(msg.sender == allMarketItems[_marketItemId].owner);
        require(_price > 0, "Listing price must be greater than zero.");
        require(
            allMarketItems[_marketItemId].sold != true,
            "item already sold out"
        );
        // require(
        //     _price > platformCommission,
        //     "Minimum platform commission is not met."
        // );

        // _itemIds.increment(); //incrementing our counter.
        // uint256 marketItemId = _itemIds.current(); //storing current value of counter in a new local variable.

        // allMarketItems[_marketItemId].seller = payable(msg.sender);
        allMarketItems[_marketItemId].price = _price;

        uint256 tokenId = allMarketItems[_marketItemId].tokenId;

        IERC721(_nftContract).transferFrom(msg.sender, address(this), tokenId); //Transfering NFT from creator to marketplace.
        allMarketItems[_marketItemId].owner == address(0);

        // emit MarketItemCreated(
        //     marketItemId,
        //     _nftContract,
        //     tokenId,
        //     msg.sender,
        //     _royalty,
        //     _price
        // );
    }

    // function transferBuy(
    //     address _recipient,
    //     uint256 _amount,
    //     uint256 _marketItemId
    // ) public payable {
    //     uint256 sellingPrice = _amount;

    //     allMarketItems[_marketItemId].owner = payable(_recipient); //Updating the ownership in local mapping to buyer who is msg.sender in this function.

    //     uint256 commission = (platformCommission * sellingPrice) / 100;

    //     payable(admin).transfer(commission); //Transfering the listing fee to the admin of the marketplace.
    //     uint256 sellerShare = ((100 - platformCommission) * sellingPrice) / 100;
    //     allMarketItems[_marketItemId].seller.transfer(sellerShare); //transferring the sale amount to the seller after deducting platform commission.
    // }

    //For buyers, To perform primary buying of the created NFT market item. Only first buyer can call this.
    // //ERC 721
    // function buyMarketItem721(address _nftContract, uint256 _marketItemId)
    //     public
    //     payable
    //     nonReentrant
    // {
    //     require(
    //         msg.sender != allMarketItems[_marketItemId].creator,
    //         "Creators can't buy from marketplace"
    //     );
    //     require(
    //         msg.value == allMarketItems[_marketItemId].price,
    //         "Must submit asking price to purchase"
    //     );

    //     transferBuy(msg.sender, msg.value, _marketItemId);

    //     uint256 tokenId = allMarketItems[_marketItemId].tokenId;
    //     IERC721(_nftContract).transferFrom(address(this), msg.sender, tokenId); //sending the NFT to buyer.
    //     _itemsSold.increment();
    // }

    // //ERC 1155
    // function buyMarketItem1155(
    //     address _nftContract,
    //     uint256 _marketItemId,
    //     uint256 amount
    // ) public payable nonReentrant {
    //     require(
    //         msg.sender != allMarketItems[_marketItemId].creator,
    //         "Creators can't buy from marketplace"
    //     );
    //     require(
    //         msg.value == allMarketItems[_marketItemId].price,
    //         "Must submit asking price to purchase"
    //     );

    //     transferBuy(msg.sender, msg.value, _marketItemId);

    //     uint256 tokenId = allMarketItems[_marketItemId].tokenId;
    //     // uint256 amount = allMarketItems[_marketItemId].amount;

    //     IERC1155(_nftContract).safeTransferFrom(
    //         address(this),
    //         msg.sender,
    //         tokenId,
    //         amount,
    //         ""
    //     ); //sending the NFT to buyer.
    //     // IERC1155(_nftContract).transferFrom(address(this), msg.sender, tokenId); //sending the NFT to buyer.

    //     _itemsSold.increment();
    // }

    function _transferBuyWETH(
        address _recipient,
        IERC20 _token,
        uint256 _amount,
        uint256 _marketItemId
    ) internal {
        // require(
        //     allMarketItems[_marketItemId].token == _token,
        //     "Tokens must be same!"
        // );
        uint256 sellingPrice = _amount;
        _token.transferFrom(_recipient, address(this), sellingPrice);

        uint256 commission = (platformCommission * sellingPrice) / 100;
        _token.transfer(admin, commission);

        address seller = allMarketItems[_marketItemId].seller;
        uint256 sellerShare = ((100 - platformCommission) * sellingPrice) / 100;
        _token.transfer(seller, sellerShare);

        // allMarketItems[_marketItemId].seller.transfer(sellerShare);
    }

    //ERC721
    function buyMarketItem721WETH(
        IERC20 _token,
        uint256 _amount,
        address _nftContract,
        uint256 _marketItemId
    ) public nonReentrant {
        require(
            msg.sender != allMarketItems[_marketItemId].seller,
            "Sellers can't buy from marketplace"
        );
        require(
            _amount == allMarketItems[_marketItemId].price,
            "Must submit asking price to purchase"
        );
        // require(_token != IERC20(address(0)));

        _transferBuyWETH(msg.sender, _token, _amount, _marketItemId);

        allMarketItems[_marketItemId].owner = msg.sender; //Updating the ownership in local mapping to buyer who is msg.sender in this function.

        uint256 tokenId = allMarketItems[_marketItemId].tokenId;
        IERC721(_nftContract).transferFrom(address(this), msg.sender, tokenId); //sending the NFT to buyer.
        allMarketItems[_marketItemId].sold = true;
        _itemsSold.increment();
    }

    //To transfer their NFTs without charging royalty, creators and users will call this.
    //ERC 721
    function transfer721(
        address _nftContract,
        uint256 _marketItemId,
        address _to
    ) public nonReentrant {
        require(
            msg.sender == allMarketItems[_marketItemId].owner,
            "Only owner can transfer the NFT"
        );

        uint256 tokenId = allMarketItems[_marketItemId].tokenId;
        address _from = allMarketItems[_marketItemId].owner;

        IERC721(_nftContract).transferFrom(_from, _to, tokenId); //Transfering the NFT.

        allMarketItems[_marketItemId].seller = _from; //setting previous owner as the seller.
        allMarketItems[_marketItemId].owner = _to; //updating the ownership of NFT to the new owner.
    }

    //To perform secondary sale of the NFT, first we'll transfer to marketplace and set the current owner as a seller.
    //ERC 721
    function secondary721saleWETH(
        address _nftContract,
        uint256 _marketItemId,
        uint256 _price
    ) public nonReentrant {
        require(
            msg.sender == allMarketItems[_marketItemId].owner,
            "Only owner can transfer the NFT"
        );
        require(_price > 0, "Listing price must be greater than zero.");

        allMarketItems[_marketItemId].price = _price; //setting new price.
        uint256 tokenId = allMarketItems[_marketItemId].tokenId;

        //set owner to address 0 (for fetchMarketItem)
        allMarketItems[_marketItemId].owner = address(0);

        IERC721(_nftContract).transferFrom(msg.sender, address(this), tokenId); //Transfering NFT from creator to marketplace.
        // allMarketItems[_marketItemId].seller = allMarketItems[_marketItemId]
        //     .owner; //setting previous owner as the seller.

        _itemsSold.decrement();

        allMarketItems[_marketItemId].seller = msg.sender;
        allMarketItems[_marketItemId].sold = false;
    }

    // function _transferSecondaryBuyWETH(
    //     address _recipient,
    //     uint256 _amount,
    //     uint256 _marketItemId
    // ) internal {
    //     IERC20 token = allMarketItems[_marketItemId].token;
    //     token.transferFrom(_recipient, address(this), _amount);

    //     uint256 royalty = (allMarketItems[_marketItemId].royalty * _amount) /
    //         100;
    //     // allMarketItems[_marketItemId].creator.transfer(royalty); //Sending royalty to the creator.
    //     address creator = allMarketItems[_marketItemId].creator; //Sending royalty to the creator.
    //     token.transfer(creator, royalty);

    //     uint256 transferAfterRoyalty = ((100 -
    //         allMarketItems[_marketItemId].royalty) * _amount) / 100;
    //     // allMarketItems[_marketItemId].seller.transfer(transferAfterRoyalty); //Sending royalty to the creator.
    //     address seller = allMarketItems[_marketItemId].seller; //Sending royalty to the creator.
    //     token.transfer(seller, transferAfterRoyalty);

    //     // address _to = msg.sender;

    //     allMarketItems[_marketItemId].owner = payable(_recipient); //updating the ownership of NFT to the new owner.
    // }

    //To perform secondary buying of the NFT from marketplace we'll charge royalty.
    //ERC 721
    // function secondary721buyWETH(
    //     uint256 _amount,
    //     address _nftContract,
    //     uint256 _marketItemId,
    //     IERC20 _token
    // ) public payable nonReentrant {
    //     // require(
    //     //     msg.sender != allMarketItems[_marketItemId].creator,
    //     //     "Creators can't buy from marketplace"
    //     // );
    //     require(
    //         msg.sender != allMarketItems[_marketItemId].seller,
    //         "Seller can't buy from marketplace"
    //     );
    //     require(
    //         _amount == allMarketItems[_marketItemId].price,
    //         "Must submit asking price to purchase"
    //     );
    //     // _transferSecondaryBuyWETH(msg.sender, _amount, _marketItemId);
    //     _transferBuyWETH(msg.sender, _token, _amount, _marketItemId);

    //     allMarketItems[_marketItemId].owner = payable(msg.sender); //Updating the ownership in local mapping to buyer who is msg.sender in this function.

    //     // address _to = msg.sender;

    //     uint256 tokenId = allMarketItems[_marketItemId].tokenId;
    //     IERC721(_nftContract).transferFrom(address(this), msg.sender, tokenId); //Transfering NFT from marketplace to new buyer.

    //     _itemsSold.increment();
    // }

    // [ FETCH DATA FUNCTIONS ]

    //To get a specific marketItem from marketplace, this function returns a structure 'marketItem' on _marketItemId input.
    function fetchMarketItem(uint256 marketItemId)
        public
        view
        returns (MarketItem memory)
    {
        return allMarketItems[marketItemId];
    }

    // To get all of the items currently for sale.
    function fetchAllMarketItems() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = _itemIds.current(); //Total number of items created so far.
        uint256 unsoldItemCount = totalItemCount - _itemsSold.current(); //Total - sold.
        uint256 currentIndex = 0; // for looping over total number of items in order to get the current index in order to populate an array.

        MarketItem[] memory items = new MarketItem[](unsoldItemCount); //creating a variable called 'items' of type MarketItem. It will hold a dynamic array, at each index of which will be a 'marketItem'. And we'll be setting 'items' to a new array with the length of the unsold items length. So we know that we want to only return the items that are unsold.

        for (uint256 i = 0; i < totalItemCount; i++) {
            //looping over the entire total items
            if (
                allMarketItems[i + 1].owner == address(0)
            ) //checking to see if the address is an empty address.
            {
                //If address is an empty address, that means this item is yet to be sold, and we want to return it. If it is not an empty address, we don't want to return it.

                //uint currentID =allMarketItems[i+1].itemId;

                uint256 currentId = i + 1; //We're using this variable as we can't pass i+1 in allMarketItems mapping, as we can't increment an address type with 1 which is of type uint. If the address is an empty address, we created an item called currentID and we set that to the value of this allMarketItems mapping. The index is starting at zero but our counter started at one so we're  going to say index plus one.

                MarketItem storage currentItem = allMarketItems[currentId]; //Now we create an another variable called 'currentItem' ,and then we set it to the value returned by the mapping 'allMarketItems' at the index 'currentId'. The value returned by 'allMarketItems' is of type 'MarketItem', which is a struct, so we  have to use 'storage' keyword.

                items[currentIndex] = currentItem;
                currentIndex += 1; //increment the value of our 'currentIndex' by one because we started it at zero and now we're going to be adding a new item on the next loop so we want to increment 'currentIndex'.
            }
        }
        return items; //this will return the market items that have not yet been sold.
    }

    function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = _itemIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (allMarketItems[i + 1].owner == msg.sender) {
                //checking to see if the address of owner is same as caller of this function.
                itemCount += 1;
            }
        }

        MarketItem[] memory myItems = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (allMarketItems[i + 1].owner == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = allMarketItems[currentId];
                myItems[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }

        return myItems;
    }

    /* Returns only items a user has created */
    function fetchItemsCreated() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = _itemIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (allMarketItems[i + 1].seller == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (allMarketItems[i + 1].seller == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = allMarketItems[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}
