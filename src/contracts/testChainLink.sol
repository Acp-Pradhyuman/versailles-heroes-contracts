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

contract TestRandomNumberConsumer is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomTokenId;
    uint16 public skinProbability;
    uint8 public commonBoxHeroProbability;
    uint8 public rareBoxHeroProbability;
    uint8 public epicBoxHeroProbability;
    uint8 public legendaryBoxHeroProbability;
    uint8 public weaponBoxRarityDrop;

    address public admin;

    struct Skins {
        uint16 normal;
        uint16 rare;
        uint16 mythic;
        uint16 legendary;
    }

    struct Weapon {
        uint8 rare;
        uint8 epic;
        uint8 legendary;
    }

    //      box              hero     skin
    mapping(uint8 => mapping(uint8 => Skins)) public boxProbabilityDistribution;

    mapping(uint8 => Weapon) public weaponProbabilityDistribution;

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

        ///@note common box probability range
        //common hero
        //[0][0] => common box and common hero
        boxProbabilityDistribution[0][0].normal = 3995;
        boxProbabilityDistribution[0][0].rare =
            2850 +
            boxProbabilityDistribution[0][0].normal;
        boxProbabilityDistribution[0][0].mythic =
            1595 +
            boxProbabilityDistribution[0][0].rare;
        boxProbabilityDistribution[0][0].legendary =
            870 +
            boxProbabilityDistribution[0][0].mythic;

        //rare hero
        //[0][1] => common box and rare hero
        boxProbabilityDistribution[0][1].normal =
            365 +
            boxProbabilityDistribution[0][0].legendary;
        boxProbabilityDistribution[0][1].rare =
            175 +
            boxProbabilityDistribution[0][1].normal;
        boxProbabilityDistribution[0][1].mythic =
            100 +
            boxProbabilityDistribution[0][1].rare;
        boxProbabilityDistribution[0][1].legendary =
            50 +
            boxProbabilityDistribution[0][1].mythic;

        ///@note rare box probability range
        //common hero
        //[1][0] => rare box and common hero
        boxProbabilityDistribution[1][0].normal = 435;
        boxProbabilityDistribution[1][0].rare =
            270 +
            boxProbabilityDistribution[1][0].normal;
        boxProbabilityDistribution[1][0].mythic =
            200 +
            boxProbabilityDistribution[1][0].rare;
        boxProbabilityDistribution[1][0].legendary =
            100 +
            boxProbabilityDistribution[1][0].mythic;

        //rare hero
        //[1][1] => rare box and rare hero
        boxProbabilityDistribution[1][1].normal =
            3445 +
            boxProbabilityDistribution[1][0].legendary;
        boxProbabilityDistribution[1][1].rare =
            2515 +
            boxProbabilityDistribution[1][1].normal;
        boxProbabilityDistribution[1][1].mythic =
            1850 +
            boxProbabilityDistribution[1][1].rare;
        boxProbabilityDistribution[1][1].legendary =
            1100 +
            boxProbabilityDistribution[1][1].mythic;

        //epic hero
        //[1][2] => rare box and epic hero
        boxProbabilityDistribution[1][2].normal =
            50 +
            boxProbabilityDistribution[1][1].legendary;
        boxProbabilityDistribution[1][2].rare =
            20 +
            boxProbabilityDistribution[1][2].normal;
        boxProbabilityDistribution[1][2].mythic =
            10 +
            boxProbabilityDistribution[1][2].rare;
        boxProbabilityDistribution[1][2].legendary =
            5 +
            boxProbabilityDistribution[1][2].mythic;

        ///@note epic box probability range
        //common hero
        //[2][0] => epic box and common hero
        boxProbabilityDistribution[2][0].normal = 15;
        boxProbabilityDistribution[2][0].rare =
            25 +
            boxProbabilityDistribution[2][0].normal;
        boxProbabilityDistribution[2][0].mythic =
            200 +
            boxProbabilityDistribution[2][0].rare;
        boxProbabilityDistribution[2][0].legendary =
            265 +
            boxProbabilityDistribution[2][0].mythic;

        //rare hero
        //[2][1] => epic box and rare hero
        boxProbabilityDistribution[2][1].normal =
            515 +
            boxProbabilityDistribution[2][0].legendary;
        boxProbabilityDistribution[2][1].rare =
            215 +
            boxProbabilityDistribution[2][1].normal;
        boxProbabilityDistribution[2][1].mythic =
            125 +
            boxProbabilityDistribution[2][1].rare;
        boxProbabilityDistribution[2][1].legendary =
            85 +
            boxProbabilityDistribution[2][1].mythic;

        //epic hero
        //[2][2] => epic box and epic hero
        boxProbabilityDistribution[2][2].normal =
            3295 +
            boxProbabilityDistribution[2][1].legendary;
        boxProbabilityDistribution[2][2].rare =
            2350 +
            boxProbabilityDistribution[2][2].normal;
        boxProbabilityDistribution[2][2].mythic =
            1505 +
            boxProbabilityDistribution[2][2].rare;
        boxProbabilityDistribution[2][2].legendary =
            965 +
            boxProbabilityDistribution[2][2].mythic;

        //legendary hero
        //[2][3] => epic box and legendary hero
        boxProbabilityDistribution[2][3].normal =
            225 +
            boxProbabilityDistribution[2][2].legendary;
        boxProbabilityDistribution[2][3].rare =
            175 +
            boxProbabilityDistribution[2][3].normal;
        boxProbabilityDistribution[2][3].mythic =
            35 +
            boxProbabilityDistribution[2][3].rare;
        boxProbabilityDistribution[2][3].legendary =
            5 +
            boxProbabilityDistribution[2][3].mythic;

        ///@note legendary box probability range
        //rare hero
        //[3][1] => legendary box and rare hero
        boxProbabilityDistribution[3][1].normal = 55;
        boxProbabilityDistribution[3][1].rare =
            85 +
            boxProbabilityDistribution[3][1].normal;
        boxProbabilityDistribution[3][1].mythic =
            125 +
            boxProbabilityDistribution[3][1].rare;
        boxProbabilityDistribution[3][1].legendary =
            175 +
            boxProbabilityDistribution[3][1].mythic;

        //epic hero
        //[3][2] => legendary box and epic hero
        boxProbabilityDistribution[3][2].normal =
            235 +
            boxProbabilityDistribution[3][1].legendary;
        boxProbabilityDistribution[3][2].rare =
            365 +
            boxProbabilityDistribution[3][2].normal;
        boxProbabilityDistribution[3][2].mythic =
            595 +
            boxProbabilityDistribution[3][2].rare;
        boxProbabilityDistribution[3][2].legendary =
            825 +
            boxProbabilityDistribution[3][2].mythic;

        //legendary hero
        //[3][3] => legendary box and legendary hero
        boxProbabilityDistribution[3][3].normal =
            3295 +
            boxProbabilityDistribution[3][2].legendary;
        boxProbabilityDistribution[3][3].rare =
            2215 +
            boxProbabilityDistribution[3][3].normal;
        boxProbabilityDistribution[3][3].mythic =
            1675 +
            boxProbabilityDistribution[3][3].rare;
        boxProbabilityDistribution[3][3].legendary =
            355 +
            boxProbabilityDistribution[3][3].mythic;

        ///@note weapon box probability range
        weaponProbabilityDistribution[4].rare = 78;
        weaponProbabilityDistribution[4].epic =
            20 +
            weaponProbabilityDistribution[4].rare;
        weaponProbabilityDistribution[4].legendary =
            2 +
            weaponProbabilityDistribution[4].epic;
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
        randomTokenId = (randomness % 10000000000);
        skinProbability = uint16(randomness % 10000);
        commonBoxHeroProbability = uint8(randomness % 2);
        rareBoxHeroProbability = uint8(randomness % 3);
        epicBoxHeroProbability = uint8(randomness % 4);
        legendaryBoxHeroProbability = uint8(randomness % 3) + 1;
        weaponBoxRarityDrop = uint8(randomness % 100);
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
                skinProbability >= 0 &&
                skinProbability <
                boxProbabilityDistribution[0][commonBoxHeroProbability].normal
            ) {
                return "normal";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[0][commonBoxHeroProbability]
                    .normal &&
                skinProbability <
                boxProbabilityDistribution[0][commonBoxHeroProbability].rare
            ) {
                return "rare";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[0][commonBoxHeroProbability].rare &&
                skinProbability <
                boxProbabilityDistribution[0][commonBoxHeroProbability].mythic
            ) {
                return "mythic";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[0][commonBoxHeroProbability]
                    .mythic &&
                skinProbability <
                boxProbabilityDistribution[0][commonBoxHeroProbability]
                    .legendary
            ) {
                return "legendary";
            }
        } else if (commonBoxHeroProbability == 1) {
            if (
                skinProbability >=
                boxProbabilityDistribution[0][commonBoxHeroProbability - 1]
                    .legendary &&
                skinProbability <
                boxProbabilityDistribution[0][commonBoxHeroProbability].normal
            ) {
                return "normal";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[0][commonBoxHeroProbability]
                    .normal &&
                skinProbability <
                boxProbabilityDistribution[0][commonBoxHeroProbability].rare
            ) {
                return "rare";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[0][commonBoxHeroProbability].rare &&
                skinProbability <
                boxProbabilityDistribution[0][commonBoxHeroProbability].mythic
            ) {
                return "mythic";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[0][commonBoxHeroProbability]
                    .mythic &&
                skinProbability <
                boxProbabilityDistribution[0][commonBoxHeroProbability]
                    .legendary
            ) {
                return "legendary";
            }
        }
    }

    function getRareBoxSkin() public view returns (string memory) {
        if (rareBoxHeroProbability == 0) {
            if (
                skinProbability >= 0 &&
                skinProbability <
                boxProbabilityDistribution[1][rareBoxHeroProbability].normal
            ) {
                return "normal";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[1][rareBoxHeroProbability].normal &&
                skinProbability <
                boxProbabilityDistribution[1][rareBoxHeroProbability].rare
            ) {
                return "rare";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[1][rareBoxHeroProbability].rare &&
                skinProbability <
                boxProbabilityDistribution[1][rareBoxHeroProbability].mythic
            ) {
                return "mythic";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[1][rareBoxHeroProbability].mythic &&
                skinProbability <
                boxProbabilityDistribution[1][rareBoxHeroProbability].legendary
            ) {
                return "legendary";
            }
        } else if (rareBoxHeroProbability == 1 || rareBoxHeroProbability == 2) {
            if (
                skinProbability >=
                boxProbabilityDistribution[1][rareBoxHeroProbability - 1]
                    .legendary &&
                skinProbability <
                boxProbabilityDistribution[1][rareBoxHeroProbability].normal
            ) {
                return "normal";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[1][rareBoxHeroProbability].normal &&
                skinProbability <
                boxProbabilityDistribution[1][rareBoxHeroProbability].rare
            ) {
                return "rare";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[1][rareBoxHeroProbability].rare &&
                skinProbability <
                boxProbabilityDistribution[1][rareBoxHeroProbability].mythic
            ) {
                return "mythic";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[1][rareBoxHeroProbability].mythic &&
                skinProbability <
                boxProbabilityDistribution[1][rareBoxHeroProbability].legendary
            ) {
                return "legendary";
            }
        }
    }

    function getEpicBoxSkin() public view returns (string memory) {
        if (epicBoxHeroProbability == 0) {
            if (
                skinProbability >= 0 &&
                skinProbability <
                boxProbabilityDistribution[2][epicBoxHeroProbability].normal
            ) {
                return "normal";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[2][epicBoxHeroProbability].normal &&
                skinProbability <
                boxProbabilityDistribution[2][epicBoxHeroProbability].rare
            ) {
                return "rare";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[2][epicBoxHeroProbability].rare &&
                skinProbability <
                boxProbabilityDistribution[2][epicBoxHeroProbability].mythic
            ) {
                return "mythic";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[2][epicBoxHeroProbability].mythic &&
                skinProbability <
                boxProbabilityDistribution[2][epicBoxHeroProbability].legendary
            ) {
                return "legendary";
            }
        } else if (
            epicBoxHeroProbability == 1 ||
            epicBoxHeroProbability == 2 ||
            epicBoxHeroProbability == 3
        ) {
            if (
                skinProbability >=
                boxProbabilityDistribution[2][epicBoxHeroProbability - 1]
                    .legendary &&
                skinProbability <
                boxProbabilityDistribution[2][epicBoxHeroProbability].normal
            ) {
                return "normal";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[2][epicBoxHeroProbability].normal &&
                skinProbability <
                boxProbabilityDistribution[2][epicBoxHeroProbability].rare
            ) {
                return "rare";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[2][epicBoxHeroProbability].rare &&
                skinProbability <
                boxProbabilityDistribution[2][epicBoxHeroProbability].mythic
            ) {
                return "mythic";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[2][epicBoxHeroProbability].mythic &&
                skinProbability <
                boxProbabilityDistribution[2][epicBoxHeroProbability].legendary
            ) {
                return "legendary";
            }
        }
    }

    function getLegendaryBoxSkin() public view returns (string memory) {
        if (legendaryBoxHeroProbability == 1) {
            if (
                skinProbability >= 0 &&
                skinProbability <
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .normal
            ) {
                return "normal";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .normal &&
                skinProbability <
                boxProbabilityDistribution[3][legendaryBoxHeroProbability].rare
            ) {
                return "rare";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .rare &&
                skinProbability <
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .mythic
            ) {
                return "mythic";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .mythic &&
                skinProbability <
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .legendary
            ) {
                return "legendary";
            }
        } else if (
            legendaryBoxHeroProbability == 2 || legendaryBoxHeroProbability == 3
        ) {
            if (
                skinProbability >=
                boxProbabilityDistribution[3][legendaryBoxHeroProbability - 1]
                    .legendary &&
                skinProbability <
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .normal
            ) {
                return "normal";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .normal &&
                skinProbability <
                boxProbabilityDistribution[3][legendaryBoxHeroProbability].rare
            ) {
                return "rare";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .rare &&
                skinProbability <
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .mythic
            ) {
                return "mythic";
            } else if (
                skinProbability >=
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .mythic &&
                skinProbability <
                boxProbabilityDistribution[3][legendaryBoxHeroProbability]
                    .legendary
            ) {
                return "legendary";
            }
        }
    }

    function getWeaponBoxRarityDrop() public view returns (string memory) {
        if (
            weaponBoxRarityDrop >= 0 &&
            weaponBoxRarityDrop < weaponProbabilityDistribution[4].rare
        ) {
            return "rare";
        } else if (
            weaponBoxRarityDrop >= weaponProbabilityDistribution[4].rare &&
            weaponBoxRarityDrop < weaponProbabilityDistribution[4].epic
        ) {
            return "epic";
        } else if (
            weaponBoxRarityDrop >= weaponProbabilityDistribution[4].epic &&
            weaponBoxRarityDrop < weaponProbabilityDistribution[4].legendary
        ) {
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

    function setSkinProbability(uint16 _skinProbability) public {
        skinProbability = _skinProbability;
    }
}
