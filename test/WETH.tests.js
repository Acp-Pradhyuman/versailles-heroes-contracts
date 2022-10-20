
const FeeCollector = artifacts.require("FeeCollector")
const Tether = artifacts.require("Tether")
const WETH = artifacts.require("WETH9")
// const Selector = artifacts.require("Selector");

require('chai').use(require('chai-as-promised')).should()

contract('FeeCollector', ([owner, customer, customer2, customer3, customer4, customer5]) => {         // contract('DecentralBank', (accounts) =>
    let tether, weth, feeCollector

    function tokens(number) {
        return web3.utils.toWei(number, 'ether')
    }

    describe("WETH", function () {
        it("should deploy contracts", async function () {
          tether = await Tether.new();
          weth = await WETH.new()
          feeCollector = await FeeCollector.new();
        });

        it("transfer Tether tokens to FeeCollector and then to the customer", async function () {
          await tether.transfer(feeCollector.address, tokens('100'), {from: owner})

          let balance = await tether.balanceOf(feeCollector.address)
          console.log("balanceOf FeeCollector before transferERC20 :", balance.toString())

          await feeCollector.transferERC20(tether.address, customer, tokens('100'), {from: owner})

          balance = await tether.balanceOf(customer)
          console.log("balanceOf customer :", balance.toString())

          balance = await tether.balanceOf(feeCollector.address)
          console.log("balanceOf FeeCollector after transferERC20 :", balance.toString())
        });

        it("transfer WETH tokens to FeeCollector and then to the customer", async function () {
          await weth.transfer(feeCollector.address, tokens('100'), {from: owner})

          let balance = await weth.balanceOf(feeCollector.address)
          console.log("balanceOf FeeCollector before transferERC20 :", balance.toString())

          await feeCollector.transferERC20(weth.address, customer, tokens('100'), {from: owner})

          balance = await weth.balanceOf(customer)
          console.log("balanceOf customer :", balance.toString())

          balance = await weth.balanceOf(feeCollector.address)
          console.log("balanceOf FeeCollector after transferERC20 :", balance.toString())

          // let totaSupply = await weth.totalSupply()
          // console.log('WETH totalSupply :', totaSupply.toString())

          // let balance = await weth.balanceOf(owner)
          // console.log("balanceOf owner :", balance.toString())
        });
      });
      


})


