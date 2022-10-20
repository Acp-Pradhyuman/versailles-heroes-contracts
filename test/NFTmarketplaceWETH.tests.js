// const Market = artifacts.require("NFTMarket");
const Market = artifacts.require("nftMarketplace9");
const NFT721 = artifacts.require("NFT2");
// const Tether = artifacts.require("Tether")
const Tether = artifacts.require("WETH9")
// const WETH = artifacts.require("WETH9")
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
          tether = await Tether.new();
          // feeCollector = await FeeCollector.new();
          // selector = await Selector.new();
          // const nftContractAddress = nft.address;
      
        //   //get the listing price
        //   let listingPrice = await market.getListingPrice();
        //   listingPrice = listingPrice.toString();
      
          //set an auction price
          auctionPrice = tokens('1');
          auctionPrice1 = tokens('2');

          await tether.transfer(customer, tokens('100'), { from: owner })
          await tether.transfer(customer2, tokens('100'), { from: owner })
          await tether.transfer(customer3, tokens('100'), { from: owner })
          await tether.transfer(customer4, tokens('100'), { from: owner })

        });




        it("should mint/create tokens, ERC 721", async function () {
          //ERC721
          admin = await nft721.admin()
          console.log("nft contract Admin :", admin)

          await nft721.updateAdmin(customer5)
          admin = await nft721.admin()
          console.log("nft contract updated Admin :", admin)

          await nft721.createToken(customer, 1000, "https://www.mytokenlocation.com", {from: admin});
          tokenURI721 = await nft721.tokenURI(1000)
          console.log("created token 721 Uri :", tokenURI721)
          // await nft.createToken("https://www.mytokenlocation2.com", {from: customer2});

          admin = await market.admin()
          console.log("marketplace Admin :", admin)
        });




        it("should create market item and change admin", async function () {
          
          // await market.createMarketItem721WETH(nft721.address, 1000, auctionPrice, 5, tether.address, {from: customer});
          await nft721.setApprovalForAll(market.address, true, {from: customer});
          await market.createMarketItem721WETH(nft721.address, 1000, auctionPrice, {from: customer});

          await market.updateAdmin(customer5, {from: owner})

          admin = await market.admin()
          console.log("new Admin :", admin)

          let allMarketItems = await market.allMarketItems(1)
          console.log("allMarketItems sold createMarketItem721WETH :", allMarketItems.sold)
        });




        it("buy, secondary sale and buy of ERC 721", async function () {
          await market.removeMarketItem721WETH(nft721.address, 1, {from: customer});
          await market.updateMarketItem721WETH(nft721.address, 1, auctionPrice1, {from: customer});

          let admin = await market.admin()
          console.log("admin :", admin)

          let allMarketItems = await market.allMarketItems(1)
          console.log("allMarketItems :", allMarketItems.seller)
          console.log("allMarketItems sold updateMarketItem721WETH :", allMarketItems.sold)

          let platformCommission = await market.platformCommission()
          console.log("platform commission :", platformCommission.toString())

          let commission = (Number(platformCommission.toString()) * Number(allMarketItems.price.toString())) / 100;
          console.log("commission :", commission)

          let sellerShare = ((100 - Number(platformCommission.toString())) * Number(allMarketItems.price.toString())) / 100;
          console.log("seller share :", sellerShare)

          let balance = await tether.balanceOf(customer2)
          console.log("Tether balance of customer2/buyer before buying :", balance.toString())

          balance = await tether.balanceOf(admin)
          console.log("Tether balance of admin before buying:",balance.toString())

          await tether.approve(market.address, allMarketItems.price.toString(), {from : customer2})
          await market.buyMarketItem721WETH(tether.address, allMarketItems.price.toString(), nft721.address, 1,  {from: customer2});

          allMarketItems = await market.allMarketItems(1)
          console.log("allMarketItems sold buyMarketItem721WETH :", allMarketItems.sold)

          balance = await tether.balanceOf(customer2)
          console.log("Tether balance of customer2/buyer after buying :", balance.toString())

          balance = await tether.balanceOf(market.address)
          console.log("Tether balance of marketplace :",balance.toString())

          balance = await tether.balanceOf(allMarketItems.seller)
          console.log("Tether balance of seller :",balance.toString())

          balance = await tether.balanceOf(admin)
          console.log("Tether balance of admin after buying :",balance.toString())
        
          
          //customer 2
          await nft721.setApprovalForAll(market.address, true, {from: customer2});
          await market.secondary721saleWETH(nft721.address, 1, auctionPrice, {from: customer2});

          allMarketItems = await market.allMarketItems(1)
          console.log("allMarketItems sold secondary721saleWETH :", allMarketItems.sold)


          // secondaryNFTbuy(address _nftContract, uint256 _marketItemId)

          await tether.approve(market.address, auctionPrice, {from : customer3})
          await market.buyMarketItem721WETH(tether.address, auctionPrice, nft721.address, 1, {from: customer3})

          allMarketItems = await market.allMarketItems(1)
          console.log("allMarketItems sold buyMarketItem721WETH :", allMarketItems.sold)

          balance = await tether.balanceOf(customer2)
          console.log("Tether balance of customer2/seller :", balance.toString())

          balance = await tether.balanceOf(customer3)
          console.log("Tether balance of customer3/buyer :", balance.toString())

          balance = await tether.balanceOf(admin)
          console.log("Tether balance of admin after buying :",balance.toString())
          
          
        });


        it("burn token and set token URI of ERC 721. secondary sale & buy of ERC 721", async function () {          
          //ERC 721
          await nft721.setApprovalForAll(market.address, true, {from: customer3});
          await market.transfer721(nft721.address, 1, customer4, {from: customer3})
          // customer 3 -> customer 4
          await nft721.setApprovalForAll(market.address, true, {from: customer4});
          await market.secondary721saleWETH(nft721.address, 1, auctionPrice, {from: customer4});

          // secondaryNFTbuy(address _nftContract, uint256 _marketItemId)

          await market.removeMarketItem721WETH(nft721.address, 1, {from: customer4});
          await market.updateMarketItem721WETH(nft721.address, 1, auctionPrice1, {from: customer4});

          await market.updatePlatformCommision(5, {from: customer5})
          console.log("platform commission updated to 5%")

          let balance = await tether.balanceOf(customer2)
          console.log("Tether balance of customer2/buyer before buying :", balance.toString())

          balance = await tether.balanceOf(customer4)
          console.log("Tether balance of customer4/seller before buying :", balance.toString())

          await tether.approve(market.address, auctionPrice1, {from : customer2})
          await market.buyMarketItem721WETH(tether.address, auctionPrice1, nft721.address, 1, {from: customer2})

          balance = await tether.balanceOf(customer2)
          console.log("Tether balance of customer2/buyer after buying :", balance.toString())

          balance = await tether.balanceOf(customer4)
          console.log("Tether balance of customer4/seller after buying :", balance.toString())
          
          // await nft721.burn(1000, {from: customer2})

          await nft721.setTokenURI(1000, "https://www.myNFT.com", {from: customer2})
          
          tokenURI721 = await nft721.tokenURI(1000)
          console.log("updated token 721 URI :", tokenURI721)

          //only owner of the token can burn it
          let ownerOf = await nft721.ownerOf(1000)
          console.log("owner of token id 1000 :", ownerOf)
          await nft721.burn(1000, {from: customer2})

          let admin = await market.admin()
          console.log("admin :", admin)

          balance = await tether.balanceOf(admin)
          console.log("Tether balance of admin :",balance.toString())



          // await nft721.createToken(1000, "https://www.mytokenlocation.com", {from: customer});
        });
      });
      


})


