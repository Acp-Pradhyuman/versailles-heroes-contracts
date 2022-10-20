const Market = artifacts.require("nftMarketplace10");
// const NFT721 = artifacts.require("NFT2");
const NFT721 = artifacts.require("NFT13");
const Box = artifacts.require("BoxHub1");
const Tether = artifacts.require("Tether")
const BUSD = artifacts.require("BUSD")
const RandomNumberConsumer = artifacts.require("RandomNumberConsumer1")
const MOH = artifacts.require("ERC20Token")
const UpgradeHero = artifacts.require("UpgradeHero")


module.exports = async function (deployer, network, accounts) {
    // await deployer.deploy(Tether)
    // const tether = await Tether.deployed()

    // await deployer.deploy(Market)
    // const market = await Market.deployed()

    await deployer.deploy(NFT721, "0xD52bBD1107667FA76e3BDEdB66b110c7E363d148")
    // // const nft = await NFT.deployed();
    // await deployer.deploy(Box)
    // await deployer.deploy(Tether)

    // await deployer.deploy(RandomNumberConsumer)
    // await deployer.deploy(MOH)
    // await deployer.deploy(UpgradeHero)
}

// Deploying 'Tether'
// ------------------
// > transaction hash:    0x85d59906e0e61c423e4e95c1596323be6f47bbd2a5ce38ddc2e62a6baeb1c68c
// > Blocks: 5            Seconds: 9
// > contract address:    0x4f0fA1A2420B5B069E18eb8a480eD50Ee36B3B45

// Deploying 'BoxHub'
// ------------------
// > transaction hash:    0x14a4d65a943b0b59cef793acd3da3423e4e42cab2e87b0dc4b213246b4aa4370
// > Blocks: 1            Seconds: 13
// > contract address:    0x70934Ac5E0E6B47A081a6382836FA044193e1dE1

// Replacing 'NFT2'
//    ----------------
//    > transaction hash:    0x3f673169589b1f1dced1ce9caf32e13939e99682343cb6b222ec740d403827af
//    > Blocks: 3            Seconds: 13
//    > contract address:    0xC3cDCd1c0609C1651e316d64CDE8302481720Cac

// Replacing 'nftMarketplace9'
// ---------------------------
// > transaction hash:    0x4e3df1b76bcb18bc181dfa253d85bbbc89f9fabd433d3a3a515db7d810430a44
// > Blocks: 3            Seconds: 12
// > contract address:    0xb97df387B7361C19BE77519DD20019d187977A43

// Deploying 'BUSD'
//    ----------------
//    > transaction hash:    0x1d6551852a78442df1142b7eff3296deb95b756269175903485f5f5585a1270a
//    > Blocks: 1            Seconds: 5
//    > contract address:    0x82EB9D9524aC858109CFCaDA86E0e8eBCc1E71d6

// Deploying 'BoxHub1'
//    -------------------
//    > transaction hash:    0xf7e31660ea018c95ab41010a273e060adc85828ac829371f87fa0ba248c52fb7
//    > Blocks: 3            Seconds: 9
//    > contract address:    0x1961deF9f2d9189867356dAc62C19E966418BE40

// Deploying 'RandomNumberConsumer1'
//    ---------------------------------
//    > transaction hash:    0x0e9b5a4fe805b5dc188781ffd21c3bbdfd58525c659dc78dd0534d6c75e05bd5
//    > Blocks: 1            Seconds: 4
//    > contract address:    0xaDCC0526c9d6fD265722E899a36548C1ac5C44A2

// Deploying 'ERC20Token'
//    ----------------------
//    > transaction hash:    0x0788512642c31010b76f0d516aa64507e376a58d7912247aee2a6b0a110cd6f4
//    > Blocks: 7            Seconds: 21
//    > contract address:    0x793F3eD53f5B79a5e7a454D4547e0C98c67E830d

// Deploying 'nftMarketplace10'
//    ----------------------------
//    > transaction hash:    0x221ec5c6e37f0383bc4d6f52edec0b306156625ed452cd50bd0207c6e896bb1c
//    > Blocks: 3            Seconds: 8
//    > contract address:    0x76d13d0E5E462e7d81589457fdFfe085A5740CC6

// Deploying 'UpgradeHero'
// -----------------------
// > transaction hash:    0x90309de6a67af1eea503d8f3a38fa2539e251ad678a63416f894bfcee414fde8
// > Blocks: 3            Seconds: 8
// > contract address:    0xAc2c3a861d844D456572d6644710679980bF3611

// Replacing 'RandomNumberConsumer1'
//    ---------------------------------
//    > transaction hash:    0xf80608ad3e1a09d98f89e2ad89750fb4f188d453524c04a2aec518c85d9b3756
//    > Blocks: 2            Seconds: 5
//    > contract address:    0x11E5Ed6E8D86cF3aEaA61cC2070d6b4e32956552

// Verifying Tether
// Pass - Verified: https://testnet.bscscan.com/address/0x4f0fA1A2420B5B069E18eb8a480eD50Ee36B3B45#code
// Verifying BoxHub
// Pass - Verified: https://testnet.bscscan.com/address/0x70934Ac5E0E6B47A081a6382836FA044193e1dE1#code
// Verifying NFT2
// Pass - Verified: https://testnet.bscscan.com/address/0xC3cDCd1c0609C1651e316d64CDE8302481720Cac#code
// Verifying nftMarketplace9
// Pass - Verified: https://testnet.bscscan.com/address/0xb97df387B7361C19BE77519DD20019d187977A43#code
// Successfully verified 4 contract(s).


// Verifying BUSD
// Pass - Verified: https://testnet.bscscan.com/address/0x82EB9D9524aC858109CFCaDA86E0e8eBCc1E71d6#code
// Successfully verified 1 contract(s).

// Verifying BoxHub1
// Pass - Verified: https://testnet.bscscan.com/address/0x1961deF9f2d9189867356dAc62C19E966418BE40#code
// Successfully verified 1 contract(s).

// Verifying RandomNumberConsumer1
// Pass - Verified: https://testnet.bscscan.com/address/0xaDCC0526c9d6fD265722E899a36548C1ac5C44A2#code
// Successfully verified 1 contract(s).

// Verifying ERC20Token
// Pass - Verified: https://testnet.bscscan.com/address/0x793F3eD53f5B79a5e7a454D4547e0C98c67E830d#code
// Successfully verified 1 contract(s).

// Verifying nftMarketplace10
// Pass - Verified: https://testnet.bscscan.com/address/0x76d13d0E5E462e7d81589457fdFfe085A5740CC6#code
// Successfully verified 1 contract(s).

// Verifying UpgradeHero
// Contract source code already verified: https://testnet.bscscan.com/address/0xAc2c3a861d844D456572d6644710679980bF3611#code
// Successfully verified 1 contract(s).

// Verifying RandomNumberConsumer1
// Pass - Verified: https://testnet.bscscan.com/address/0x11E5Ed6E8D86cF3aEaA61cC2070d6b4e32956552#code
// Successfully verified 1 contract(s).