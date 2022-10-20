// const Market = artifacts.require("NFTMarket");
const Box = artifacts.require("UpgradeHero");
// const NFT721 = artifacts.require("NFT2");
// const Tether = artifacts.require("Tether")
const Tether = artifacts.require("WETH9")
// const WETH = artifacts.require("WETH9")
// const FeeCollector = artifacts.require("FeeCollector")
// const Tether = artifacts.require("Tether")
// const Selector = artifacts.require("Selector");

require('chai').use(require('chai-as-promised')).should()

contract('UpgradeHero', ([owner, customer, customer2, customer3, customer4, customer5]) => {         // contract('DecentralBank', (accounts) =>
    let market, nft1155, nft721, auctionPrice, auctionPrice1, tokenURI721, tokenURI1155, admin, selector, tether, feeCollector, box

    function tokens(number) {
        return web3.utils.toWei(number, 'ether')
    }

    describe("Upgrade Hero Contract", function () {
        it("should deploy contracts", async function () {
          // market = await Market.new();
          // nft721 = await NFT721.new(market.address);
          box = await Box.new()
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




        it("should record upgraded hero and also transfer funds to the admin's wallet", async function () {
          //ERC721
          admin = await box.owner()
          console.log("box contract Admin :", admin)

          await box.transferOwnership(customer5)

          admin = await box.owner()
          console.log("updated box contract Admin :", admin)

          await box.setPaymentReceivedAddress(customer5, {from: customer5})
          
          console.log("updated box payment reciever :", customer5)

          let balance = await tether.balanceOf(customer5)
          console.log("Tether balance of payment reciever before upgrading :", balance.toString())

          balance = await tether.balanceOf(customer)
          console.log("Tether balance of customer before upgrading :", balance.toString())

          // buyBoxWithSignature(
          //   uint256 boxId,
          //   uint256 _type,
          //   address userAddress,
          //   uint256 price,
          //   address paymentErc20
          // )
          
          // use ethereum.request({method: "personal_sign", params: [account, hash]}).then(console.log)
          
          await tether.approve(box.address, auctionPrice, {from: customer})
          let result = await box.upgradeHeroPayment(auctionPrice, tether.address, {from: customer})

          balance = await tether.balanceOf(customer5)
          console.log("Tether balance of payment reciever after upgrading :", balance.toString())

          balance = await tether.balanceOf(customer)
          console.log("Tether balance of customer after upgrading  :", balance.toString())

          // console.log("result.logs[0] : ", result.logs[0])
          // console.log("result.logs[0].args : ", result.logs[0].args)

          // console.log("event :", result.logs[0].event)

          // console.log("box id :", result.logs[0].args.boxId.toString())
          // console.log("box type :", result.logs[0].args.boxType.toString())

          await tether.approve(box.address, auctionPrice, {from: customer})
          await box.upgradeHeroPayment(auctionPrice, tether.address, {from: customer})

          balance = await tether.balanceOf(customer5)
          console.log("Tether balance of payment reciever after upgrading :", balance.toString())

          balance = await tether.balanceOf(customer)
          console.log("Tether balance of customer after upgrading  :", balance.toString())

        });




        



      });
      


})


