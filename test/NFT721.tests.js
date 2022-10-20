// const Market = artifacts.require("NFTMarket");
const Market = artifacts.require("nftMarketplace8");
const NFT721 = artifacts.require("NFT2");
// const FeeCollector = artifacts.require("FeeCollector")
// const Tether = artifacts.require("Tether")
// const Selector = artifacts.require("Selector");

require('chai').use(require('chai-as-promised')).should()

contract('NFTmarket', ([owner, customer, customer2, customer3, customer4, customer5]) => {         // contract('DecentralBank', (accounts) =>
    let market, nft1155, nft721, auctionPrice, auctionPrice1, tokenURI721, tokenURI1155, admin, selector, tether, feeCollector

    function tokens(number) {
        return web3.utils.toWei(number, 'ether')
    }

    describe("NFTMarket", function () {
        it("should deploy contracts", async function () {
          market = await Market.new();
          nft721 = await NFT721.new(market.address);
          // tether = await Tether.new();
          // feeCollector = await FeeCollector.new();
          // selector = await Selector.new();
          // const nftContractAddress = nft.address;
      
        //   //get the listing price
        //   let listingPrice = await market.getListingPrice();
        //   listingPrice = listingPrice.toString();
      
          //set an auction price
          auctionPrice = tokens('1');
          auctionPrice1 = tokens('2');

        });




        it("should mint/create tokens, ERC 721", async function () {
          //ERC721
          await nft721.createToken(1000, "https://www.mytokenlocation.com", {from: customer});
          tokenURI721 = await nft721.tokenURI(1000)
          console.log("created token 721 Uri :", tokenURI721)
          // await nft.createToken("https://www.mytokenlocation2.com", {from: customer2});

          admin = await market.admin()
          console.log("Admin :", admin)
        });




        it("should create market item and change admin", async function () {
          await market.createMarketItem721(nft721.address, 1000, auctionPrice, 5, {from: customer});

          await market.updateAdmin(customer5, {from: owner})

          admin = await market.admin()
          console.log("new Admin :", admin)
        });




        it("buy, secondary sale and buy of ERC 721", async function () {
          await market.removeMarketItem721(nft721.address, 1, {from: customer});
          await market.updateMarketItem721(nft721.address, 1, auctionPrice1, {from: customer});
          await market.buyMarketItem721(nft721.address, 1,  {from: customer2, value: auctionPrice1});
        
          
          //customer 2
          await nft721.setApprovalForAll(market.address, true, {from: customer2});
          await market.secondary721sale(nft721.address, 1, auctionPrice, {from: customer2});

          // secondaryNFTbuy(address _nftContract, uint256 _marketItemId)

          await market.secondary721buy(nft721.address, 1, {from: customer3, value: auctionPrice})  
          
        });



        it("burn token and set token URI of ERC 721. secondary sale & buy of ERC 721", async function () {

          
          //ERC 721
          await nft721.setApprovalForAll(market.address, true, {from: customer3});
          await market.transfer721(nft721.address, 1, customer4, {from: customer3})
          // customer 3 -> customer 4
          await nft721.setApprovalForAll(market.address, true, {from: customer4});
          await market.secondary721sale(nft721.address, 1, auctionPrice, {from: customer4});

          // secondaryNFTbuy(address _nftContract, uint256 _marketItemId)

          await market.removeMarketItem721(nft721.address, 1, {from: customer4});
          await market.updateMarketItem721(nft721.address, 1, auctionPrice1, {from: customer4});

          //didn't update price???
          await market.secondary721buy(nft721.address, 1, {from: customer2, value: auctionPrice1})
          
          // await nft721.burn(1000, {from: customer2})

          await nft721.setTokenURI(1000, "https://www.myNFT.com", {from: customer2})
          
          tokenURI721 = await nft721.tokenURI(1000)
          console.log("updated token 721 URI :", tokenURI721)

          //only owner of the token can burn it
          await nft721.burn(1000, {from: customer2})

          // await nft721.createToken(1000, "https://www.mytokenlocation.com", {from: customer});
        });
      });
      


})


