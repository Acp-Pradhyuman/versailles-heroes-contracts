// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./HasSignature.sol";

contract BoxHub1 is Ownable, HasSignature {
    using SafeERC20 for IERC20;

    event BoxPaid(
        uint256 indexed boxId,
        address indexed buyer,
        uint256 boxType,
        uint256 price,
        address paymentToken
    );

    address public paymentReceivedAddress;
    uint256 public platformCommission;

    constructor() {
        paymentReceivedAddress = msg.sender;
        platformCommission = 2;
    }

    function setPaymentReceivedAddress(address _paymentReceivedAddress)
        public
        onlyOwner
    {
        paymentReceivedAddress = _paymentReceivedAddress;
    }

    function updatePlatformCommision(uint256 _platformCommission)
        public
        onlyOwner
    {
        platformCommission = _platformCommission;
    }

    /**
     * @dev  box payment buy function
     */
    function buyBoxWithSignature(
        uint256 boxId,
        uint256 _type,
        address userAddress,
        uint256 price,
        address paymentErc20,
        bytes calldata signature
    )
        external
        // bytes calldata signature
        onlyOwner
    {
        require(
            !isContract(userAddress),
            "BoxPayment: Only user address is allowed to buy box"
        );
        require(_type < 5, "BoxPayment: Invalid box type");
        require(price > 0, "BoxPayment: Invalid payment amount");
        bytes32 criteriaMessageHash = getMessageHash(_type, price);

        bytes32 ethSignedMessageHash = getEthSignedMessageHash(
            criteriaMessageHash
        );

        require(
            recoverSigner(ethSignedMessageHash, signature) == userAddress,
            "BoxPayment: invalid buyer signature"
        );

        IERC20 paymentToken = IERC20(paymentErc20);
        uint256 allowToPayAmount = paymentToken.allowance(
            userAddress,
            address(this)
        );
        require(
            allowToPayAmount >= price,
            "BoxPayment: Invalid token allowance"
        );
        // Transfer payment
        paymentToken.safeTransferFrom(
            userAddress,
            paymentReceivedAddress,
            price
        );
        // Emit payment event
        emit BoxPaid(boxId, userAddress, _type, price, paymentErc20);
    }

    function TransferBox(
        uint256 boxId,
        uint256 boxType,
        address boxOwner,
        address boxReciever,
        address paymentErc20,
        uint256 price
    ) external onlyOwner {
        // require(boxOwner == msg.sender, "only a box owner can call this function");
        require(
            !isContract(boxReciever),
            "BoxPayment: Only user address is allowed to buy box"
        );

        IERC20 paymentToken = IERC20(paymentErc20);
        uint256 allowToPayAmount = paymentToken.allowance(
            boxReciever,
            address(this)
        );
        require(
            allowToPayAmount >= price,
            "BoxPayment: Invalid token allowance"
        );

        paymentToken.safeTransferFrom(
            boxReciever,
            boxOwner,
            ((price * (100 - platformCommission)) / 100)
        );
        paymentToken.safeTransferFrom(
            boxReciever,
            paymentReceivedAddress,
            (price * platformCommission) / 100
        );

        emit BoxPaid(boxId, boxReciever, boxType, price, paymentErc20);
    }

    function getMessageHash(uint256 _boxType, uint256 _price)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_boxType, _price));
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
