// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// import "./HasSignature.sol";

contract UpgradeHero is Ownable {
    using SafeERC20 for IERC20;

    event UpgradeHeroPaid(uint256 price, address paymentToken);

    address public paymentReceivedAddress;
    uint256 public platformCommission;

    constructor() {
        paymentReceivedAddress = msg.sender;
    }

    function setPaymentReceivedAddress(address _paymentReceivedAddress)
        public
        onlyOwner
    {
        paymentReceivedAddress = _paymentReceivedAddress;
    }

    /**
     * @dev  box payment buy function
     */
    function upgradeHeroPayment(uint256 price, address paymentErc20) external {
        require(
            !isContract(msg.sender),
            "BoxPayment: Only user address is allowed to buy box"
        );
        require(price > 0, "UpgradeHeroPayment: Invalid payment amount");

        IERC20 paymentToken = IERC20(paymentErc20);
        uint256 allowToPayAmount = paymentToken.allowance(
            msg.sender,
            address(this)
        );
        require(
            allowToPayAmount >= price,
            "UpgradeHeroPayment: Invalid token allowance"
        );
        // Transfer payment
        paymentToken.safeTransferFrom(
            msg.sender,
            paymentReceivedAddress,
            price
        );
        // Emit payment event
        emit UpgradeHeroPaid(price, paymentErc20);
    }

    /**
     * @dev Identify an address is user address or contract address
     */
    function isContract(address _address) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_address)
        }
        return (size > 0);
    }
}
