// const Market = artifacts.require("NFTMarket");
const Box = artifacts.require("BoxHub1");
// const NFT721 = artifacts.require("NFT2");
// const Tether = artifacts.require("Tether")
const Tether = artifacts.require("WETH9")
// const WETH = artifacts.require("WETH9")
// const FeeCollector = artifacts.require("FeeCollector")
// const Tether = artifacts.require("Tether")
// const Selector = artifacts.require("Selector");

require('chai').use(require('chai-as-promised')).should()

contract('NFTmarket', ([owner, customer, customer2, customer3, customer4, customer5]) => {         // contract('DecentralBank', (accounts) =>
    let market, nft1155, nft721, auctionPrice, auctionPrice1, tokenURI721, tokenURI1155, admin, selector, tether, feeCollector, box

    function tokens(number) {
        return web3.utils.toWei(number, 'ether')
    }

    describe("Box purchase and transfer Contract", function () {
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




        it("should record box transfers and also transfer funds to the admin's wallet", async function () {
          //ERC721
          admin = await box.owner()
          console.log("box contract Admin :", admin)

          await box.transferOwnership(customer5)

          admin = await box.owner()
          console.log("updated box contract Admin :", admin)

          await box.setPaymentReceivedAddress(customer5, {from: customer5})

          console.log("updated box payment reciever :", customer5)

          let balance = await tether.balanceOf(customer5)
          console.log("Tether balance of payment reciever before buying :", balance.toString())

          balance = await tether.balanceOf(customer)
          console.log("Tether balance of customer before buying :", balance.toString())

          // buyBoxWithSignature(
          //   uint256 boxId,
          //   uint256 _type,
          //   address userAddress,
          //   uint256 price,
          //   address paymentErc20
          // )

          // use ethereum.request({method: "personal_sign", params: [account, hash]}).then(console.log)

          let signature1 = "0xec001840ee3b24e928303007eb830a9c2e59c51ee3c07afdf49c3fcad187fbaf0ebcd1a20544157a9beffb5b92bb320468e9fa88ad1fa75314722e30ddb899501c"
          // signed by 0x50A2E11a8294e3c7bE675cC249662F97461aCCDF (private key: 435d33ea755fd86c5060afb81475349cd677f0d028dfd5df40faec9e16d686ad)
          // message hash : '0x39cc4bcb6520e3600c1fee354a1bc90a4ac4bbbf628b29223c6896f1e62a5559'
          let messageHash = await box.getMessageHash(3, auctionPrice)
          console.log("message hash : ", messageHash)

          let signature2 = await web3.eth.sign(messageHash, customer)
          console.log("signature2 : ", signature2)

          console.log("auction price : ", auctionPrice)

          await tether.approve(box.address, auctionPrice, {from: customer})
          let result = await box.buyBoxWithSignature(1000, 3, customer, auctionPrice, tether.address, signature1, {from: customer5})

          balance = await tether.balanceOf(customer5)
          console.log("Tether balance of payment reciever after buying :", balance.toString())

          balance = await tether.balanceOf(customer)
          console.log("Tether balance of customer after buying  :", balance.toString())

          // console.log("result.logs[0] : ", result.logs[0])
          // console.log("result.logs[0].args : ", result.logs[0].args)

          // console.log("event :", result.logs[0].event)

          // console.log("box id :", result.logs[0].args.boxId.toString())
          // console.log("box type :", result.logs[0].args.boxType.toString())

          await tether.approve(box.address, auctionPrice, {from: customer})
          await box.buyBoxWithSignature(1001, 3, customer, auctionPrice, tether.address, signature1, {from: customer5})

          balance = await tether.balanceOf(customer5)
          console.log("Tether balance of payment reciever after buying :", balance.toString())

          balance = await tether.balanceOf(customer)
          console.log("Tether balance of customer after buying  :", balance.toString())

          balance = await tether.balanceOf(customer2)
          console.log("Tether balance of customer2 before transfer  :", balance.toString())

          await tether.approve(box.address, auctionPrice, {from: customer2})
          await box.TransferBox(1001, 3, customer, customer2, tether.address, auctionPrice, {from: customer5})

          balance = await tether.balanceOf(customer5)
          console.log("Tether balance of payment reciever after transfer :", balance.toString())

          balance = await tether.balanceOf(customer)
          console.log("Tether balance of customer after transfer  :", balance.toString())

          balance = await tether.balanceOf(customer2)
          console.log("Tether balance of customer2 after transfer  :", balance.toString())

          ////////////////////////////////////////////////////////////////////////////////////////////////////////////
          balance = await tether.balanceOf(customer3)
          console.log("Tether balance of customer3 before transfer  :", balance.toString())

          await tether.approve(box.address, auctionPrice, {from: customer3})
          await box.TransferBox(1000, 3, customer, customer3, tether.address, auctionPrice, {from: customer5})

          balance = await tether.balanceOf(customer5)
          console.log("Tether balance of payment reciever after transfer :", balance.toString())

          balance = await tether.balanceOf(customer)
          console.log("Tether balance of customer after transfer  :", balance.toString())

          balance = await tether.balanceOf(customer3)
          console.log("Tether balance of customer3 after transfer  :", balance.toString())

          // let events = await box.getPastEvents('BoxPaid', { fromBlock: 0, toBlock: 'latest' })
          // let event = events.map((event) => event.returnValues.boxId)
          // console.log("result : ", event)

          // event = events.map((event) => event.returnValues)
          // console.log("result : ", event)

          // let msg = "Some data"
          // let prefix = "\x19Ethereum Signed Message:\n"
          // let msgHash = web3.utils.keccak256(msg)
          // console.log("message hash : ", msgHash)
          // let signature = await web3.eth.sign(msgHash, customer)
          // console.log("Signature :", signature)

        });








      });



})


