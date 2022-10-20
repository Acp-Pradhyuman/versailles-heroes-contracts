// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
 */

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

contract TestRandomNumberConsumer1 is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomTokenId;
    uint8 public commonBoxHeroProbability;
    uint8 public rareBoxHeroProbability;
    uint8 public epicBoxHeroProbability;
    uint8 public legendaryBoxHeroProbability;
    uint8 public weaponBoxRarityDrop;

    //common box
    uint16 public commonBoxCommonHeroSkinRarity;
    uint16 public commonBoxRareHeroSkinRarity;

    //rare box
    uint16 public rareBoxCommonHeroSkinRarity;
    uint16 public rareBoxRareHeroSkinRarity;
    uint16 public rareBoxEpicHeroSkinRarity;

    //epic box
    uint16 public epicBoxCommonHeroSkinRarity;
    uint16 public epicBoxRareHeroSkinRarity;
    uint16 public epicBoxEpicHeroSkinRarity;
    uint16 public epicBoxLegendarySkinRarity;

    //legendary box
    uint16 public legendaryBoxRareSkinRarity;
    uint16 public legendaryBoxEpicSkinRarity;
    uint16 public legendaryBoxLegendarySkinRarity;

    address public admin;

    /**
     * Constructor inherits VRFConsumerBase
     *
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     *
     * Network: BSC testnet
     * Chainlink VRF Coordinator address: 0xa555fC018435bef5A13C6c6870a9d4C11DEC329C
     * LINK token address:                0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06
     * Key Hash: 0xcaf3c3727e033261d383b315559476f48034c13b18f8cafed4d871abe5049186
     *
     * Links
     * https://docs.chain.link/docs/get-a-random-number/v1/
     * https://docs.chain.link/docs/vrf-contracts/v1/
     */
    constructor()
        VRFConsumerBase(
            0xa555fC018435bef5A13C6c6870a9d4C11DEC329C, // VRF Coordinator
            0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06 // LINK Token
        )
    {
        keyHash = 0xcaf3c3727e033261d383b315559476f48034c13b18f8cafed4d871abe5049186;
        fee = 0.1 * 10**18; // 0.1 LINK (Varies by network)
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can access this");
        _;
    }

    function updateAdmin(address _admin) public onlyAdmin {
        admin = _admin;
    }

    /**
     * Requests randomness
     */
    function getRandomNumber() public returns (bytes32 requestId) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomTokenId = (randomness % 10000000000000000);
        commonBoxHeroProbability = uint8(randomness % 2);
        rareBoxHeroProbability = uint8(randomness % 3);
        epicBoxHeroProbability = uint8(randomness % 4);
        legendaryBoxHeroProbability = uint8(randomness % 3) + 1;
        weaponBoxRarityDrop = uint8(randomness % 100);

        //common box
        commonBoxCommonHeroSkinRarity = uint16(randomness % 9310);
        commonBoxRareHeroSkinRarity = uint16(randomness % 690);

        //rare box
        rareBoxCommonHeroSkinRarity = uint16(randomness % 1005);
        rareBoxRareHeroSkinRarity = uint16(randomness % 8910);
        rareBoxEpicHeroSkinRarity = uint16(randomness % 85);

        //epic box
        epicBoxCommonHeroSkinRarity = uint16(randomness % 505);
        epicBoxRareHeroSkinRarity = uint16(randomness % 940);
        epicBoxEpicHeroSkinRarity = uint16(randomness % 8115);
        epicBoxLegendarySkinRarity = uint16(randomness % 440);

        //legendary box
        legendaryBoxRareSkinRarity = uint16(randomness % 440);
        legendaryBoxEpicSkinRarity = uint16(randomness % 2020);
        legendaryBoxLegendarySkinRarity = uint16(randomness % 7540);
        // randomResult = (randomness%1000);
        // randomResult
        // 0: uint256: 873
        // 0x58dc868A54D09e8E15e6352e331682a817e1f0B3 kovan network (%1000)
        // 0x6f0eBEd8C6c6e09eEaE9f01A5C7a62c16aF5f552 BSC testnet (%1000)
        // probability
        // 0: uint8: 44
        // randomTokenId
        // 0: uint256: 7638892244
        // 0x47D2EA3828633F28048a7dBC179D78C38A0d6a20 BSC testnet (probability and randomTokenId)
    }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract

    function getCommonBoxSkin() public view returns (string memory) {
        if (commonBoxHeroProbability == 0) {
            if (
                commonBoxCommonHeroSkinRarity >= 0 &&
                commonBoxCommonHeroSkinRarity < 3995
            ) {
                return "normal";
            } else if (
                commonBoxCommonHeroSkinRarity >= 3995 &&
                commonBoxCommonHeroSkinRarity < 6845
            ) {
                return "rare";
            } else if (
                commonBoxCommonHeroSkinRarity >= 6845 &&
                commonBoxCommonHeroSkinRarity < 8440
            ) {
                return "mythic";
            } else if (
                commonBoxCommonHeroSkinRarity >= 8440 &&
                commonBoxCommonHeroSkinRarity < 9310
            ) {
                return "legendary";
            }
        } else if (commonBoxHeroProbability == 1) {
            if (
                commonBoxRareHeroSkinRarity >= 0 &&
                commonBoxRareHeroSkinRarity < 365
            ) {
                return "normal";
            } else if (
                commonBoxRareHeroSkinRarity >= 365 &&
                commonBoxRareHeroSkinRarity < 540
            ) {
                return "rare";
            } else if (
                commonBoxRareHeroSkinRarity >= 540 &&
                commonBoxRareHeroSkinRarity < 640
            ) {
                return "mythic";
            } else if (
                commonBoxRareHeroSkinRarity >= 640 &&
                commonBoxRareHeroSkinRarity < 690
            ) {
                return "legendary";
            }
        }
    }

    function getRareBoxSkin() public view returns (string memory) {
        if (rareBoxHeroProbability == 0) {
            if (
                rareBoxCommonHeroSkinRarity >= 0 &&
                rareBoxCommonHeroSkinRarity < 435
            ) {
                return "normal";
            } else if (
                rareBoxCommonHeroSkinRarity >= 435 &&
                rareBoxCommonHeroSkinRarity < 705
            ) {
                return "rare";
            } else if (
                rareBoxCommonHeroSkinRarity >= 705 &&
                rareBoxCommonHeroSkinRarity < 905
            ) {
                return "mythic";
            } else if (
                rareBoxCommonHeroSkinRarity >= 905 &&
                rareBoxCommonHeroSkinRarity < 1005
            ) {
                return "legendary";
            }
        } else if (rareBoxHeroProbability == 1) {
            if (
                rareBoxRareHeroSkinRarity >= 0 &&
                rareBoxRareHeroSkinRarity < 3445
            ) {
                return "normal";
            } else if (
                rareBoxRareHeroSkinRarity >= 3445 &&
                rareBoxRareHeroSkinRarity < 5960
            ) {
                return "rare";
            } else if (
                rareBoxRareHeroSkinRarity >= 5960 &&
                rareBoxRareHeroSkinRarity < 7810
            ) {
                return "mythic";
            } else if (
                rareBoxRareHeroSkinRarity >= 7810 &&
                rareBoxRareHeroSkinRarity < 8910
            ) {
                return "legendary";
            }
        } else if (rareBoxHeroProbability == 2) {
            if (
                rareBoxEpicHeroSkinRarity >= 0 && rareBoxEpicHeroSkinRarity < 50
            ) {
                return "normal";
            } else if (
                rareBoxEpicHeroSkinRarity >= 50 &&
                rareBoxEpicHeroSkinRarity < 70
            ) {
                return "rare";
            } else if (
                rareBoxEpicHeroSkinRarity >= 70 &&
                rareBoxEpicHeroSkinRarity < 80
            ) {
                return "mythic";
            } else if (
                rareBoxEpicHeroSkinRarity >= 80 &&
                rareBoxEpicHeroSkinRarity < 85
            ) {
                return "legendary";
            }
        }
    }

    function getEpicBoxSkin() public view returns (string memory) {
        if (epicBoxHeroProbability == 0) {
            if (
                epicBoxCommonHeroSkinRarity >= 0 &&
                epicBoxCommonHeroSkinRarity < 15
            ) {
                return "normal";
            } else if (
                epicBoxCommonHeroSkinRarity >= 15 &&
                epicBoxCommonHeroSkinRarity < 40
            ) {
                return "rare";
            } else if (
                epicBoxCommonHeroSkinRarity >= 40 &&
                epicBoxCommonHeroSkinRarity < 240
            ) {
                return "mythic";
            } else if (
                epicBoxCommonHeroSkinRarity >= 240 &&
                epicBoxCommonHeroSkinRarity < 505
            ) {
                return "legendary";
            }
        } else if (epicBoxHeroProbability == 1) {
            if (
                epicBoxRareHeroSkinRarity >= 0 &&
                epicBoxRareHeroSkinRarity < 515
            ) {
                return "normal";
            } else if (
                epicBoxRareHeroSkinRarity >= 515 &&
                epicBoxRareHeroSkinRarity < 730
            ) {
                return "rare";
            } else if (
                epicBoxRareHeroSkinRarity >= 730 &&
                epicBoxRareHeroSkinRarity < 855
            ) {
                return "mythic";
            } else if (
                epicBoxRareHeroSkinRarity >= 855 &&
                epicBoxRareHeroSkinRarity < 940
            ) {
                return "legendary";
            }
        } else if (epicBoxHeroProbability == 2) {
            if (
                epicBoxEpicHeroSkinRarity >= 0 &&
                epicBoxEpicHeroSkinRarity < 3295
            ) {
                return "normal";
            } else if (
                epicBoxEpicHeroSkinRarity >= 3295 &&
                epicBoxEpicHeroSkinRarity < 5645
            ) {
                return "rare";
            } else if (
                epicBoxEpicHeroSkinRarity >= 5645 &&
                epicBoxEpicHeroSkinRarity < 7150
            ) {
                return "mythic";
            } else if (
                epicBoxEpicHeroSkinRarity >= 7150 &&
                epicBoxEpicHeroSkinRarity < 8115
            ) {
                return "legendary";
            }
        } else if (epicBoxHeroProbability == 3) {
            if (
                epicBoxLegendarySkinRarity >= 0 &&
                epicBoxLegendarySkinRarity < 225
            ) {
                return "normal";
            } else if (
                epicBoxLegendarySkinRarity >= 225 &&
                epicBoxLegendarySkinRarity < 400
            ) {
                return "rare";
            } else if (
                epicBoxLegendarySkinRarity >= 400 &&
                epicBoxLegendarySkinRarity < 435
            ) {
                return "mythic";
            } else if (
                epicBoxLegendarySkinRarity >= 435 &&
                epicBoxLegendarySkinRarity < 440
            ) {
                return "legendary";
            }
        }
    }

    function getLegendaryBoxSkin() public view returns (string memory) {
        if (legendaryBoxHeroProbability == 1) {
            if (
                legendaryBoxRareSkinRarity >= 0 &&
                legendaryBoxRareSkinRarity < 55
            ) {
                return "normal";
            } else if (
                legendaryBoxRareSkinRarity >= 55 &&
                legendaryBoxRareSkinRarity < 140
            ) {
                return "rare";
            } else if (
                legendaryBoxRareSkinRarity >= 140 &&
                legendaryBoxRareSkinRarity < 265
            ) {
                return "mythic";
            } else if (
                legendaryBoxRareSkinRarity >= 265 &&
                legendaryBoxRareSkinRarity < 440
            ) {
                return "legendary";
            }
        } else if (legendaryBoxHeroProbability == 2) {
            if (
                legendaryBoxEpicSkinRarity >= 0 &&
                legendaryBoxEpicSkinRarity < 235
            ) {
                return "normal";
            } else if (
                legendaryBoxEpicSkinRarity >= 235 &&
                legendaryBoxEpicSkinRarity < 600
            ) {
                return "rare";
            } else if (
                legendaryBoxEpicSkinRarity >= 600 &&
                legendaryBoxEpicSkinRarity < 1195
            ) {
                return "mythic";
            } else if (
                legendaryBoxEpicSkinRarity >= 1195 &&
                legendaryBoxEpicSkinRarity < 2020
            ) {
                return "legendary";
            }
        } else if (legendaryBoxHeroProbability == 3) {
            if (
                legendaryBoxLegendarySkinRarity >= 0 &&
                legendaryBoxLegendarySkinRarity < 3295
            ) {
                return "normal";
            } else if (
                legendaryBoxLegendarySkinRarity >= 3295 &&
                legendaryBoxLegendarySkinRarity < 5510
            ) {
                return "rare";
            } else if (
                legendaryBoxLegendarySkinRarity >= 5510 &&
                legendaryBoxLegendarySkinRarity < 7185
            ) {
                return "mythic";
            } else if (
                legendaryBoxLegendarySkinRarity >= 7185 &&
                legendaryBoxLegendarySkinRarity < 7540
            ) {
                return "legendary";
            }
        }
    }

    function getWeaponBoxRarityDrop() public view returns (string memory) {
        if (weaponBoxRarityDrop >= 0 && weaponBoxRarityDrop < 78) {
            return "rare";
        } else if (weaponBoxRarityDrop >= 78 && weaponBoxRarityDrop < 98) {
            return "epic";
        } else if (weaponBoxRarityDrop >= 98 && weaponBoxRarityDrop < 100) {
            return "legendary";
        }
    }

    function setCommonBoxHeroProbability(uint8 _commonBoxHeroProbability)
        public
    {
        commonBoxHeroProbability = _commonBoxHeroProbability;
    }

    function setRareBoxHeroProbability(uint8 _rareBoxHeroProbability) public {
        rareBoxHeroProbability = _rareBoxHeroProbability;
    }

    function setEpicBoxHeroProbability(uint8 _epicBoxHeroProbability) public {
        epicBoxHeroProbability = _epicBoxHeroProbability;
    }

    function setLegendaryBoxHeroProbability(uint8 _legendaryBoxHeroProbability)
        public
    {
        legendaryBoxHeroProbability = _legendaryBoxHeroProbability;
    }

    function setWeaponBoxRarityDrop(uint8 _weaponBoxRarityDrop) public {
        weaponBoxRarityDrop = _weaponBoxRarityDrop;
    }

    //common box skin rarity
    function setCommonBoxCommonHeroSkinRarity(uint16 _commonBoxCommonHeroSkinRarity) public {
        commonBoxCommonHeroSkinRarity = _commonBoxCommonHeroSkinRarity;
    }

    function setCommonBoxRareHeroSkinRarity(uint16 _commonBoxRareHeroSkinRarity) public {
        commonBoxRareHeroSkinRarity = _commonBoxRareHeroSkinRarity;
    }

    //rare box skin rarity
    function setRareBoxCommonHeroSkinRarity(uint16 _rareBoxCommonHeroSkinRarity) public {
        rareBoxCommonHeroSkinRarity = _rareBoxCommonHeroSkinRarity;
    }

    function setRareBoxRareHeroSkinRarity(uint16 _rareBoxRareHeroSkinRarity) public {
        rareBoxRareHeroSkinRarity = _rareBoxRareHeroSkinRarity;
    }

    function setRareBoxEpicHeroSkinRarity(uint16 _rareBoxEpicHeroSkinRarity) public {
        rareBoxEpicHeroSkinRarity = _rareBoxEpicHeroSkinRarity;
    }

    //epic box skin rarity
    function setEpicBoxCommonHeroSkinRarity(uint16 _epicBoxCommonHeroSkinRarity) public {
        epicBoxCommonHeroSkinRarity = _epicBoxCommonHeroSkinRarity;
    }

    function setEpicBoxRareHeroSkinRarity(uint16 _epicBoxRareHeroSkinRarity) public {
        epicBoxRareHeroSkinRarity = _epicBoxRareHeroSkinRarity;
    }

    function setEpicBoxEpicHeroSkinRarity(uint16 _epicBoxEpicHeroSkinRarity) public {
        epicBoxEpicHeroSkinRarity = _epicBoxEpicHeroSkinRarity;
    }

    function setEpicBoxLegendarySkinRarity(uint16 _epicBoxLegendarySkinRarity) public {
        epicBoxLegendarySkinRarity = _epicBoxLegendarySkinRarity;
    }

    //legendary box skin rarity
    function setLegendaryBoxRareSkinRarity(uint16 _legendaryBoxRareSkinRarity) public {
        legendaryBoxRareSkinRarity = _legendaryBoxRareSkinRarity;
    }

    function setLegendaryBoxEpicSkinRarity(uint16 _legendaryBoxEpicSkinRarity) public {
        legendaryBoxEpicSkinRarity = _legendaryBoxEpicSkinRarity;
    }

    function setLegendaryBoxLegendarySkinRarity(uint16 _legendaryBoxLegendarySkinRarity) public {
        legendaryBoxLegendarySkinRarity = _legendaryBoxLegendarySkinRarity;
    }
}
