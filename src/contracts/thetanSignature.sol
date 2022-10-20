// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VerifySig {
    function verify(
        address _signer,
        uint256 _type,
        uint256 price,
        address paymentErc20,
        bytes memory _sig
    ) external pure returns (bool) {
        bytes32 messageHash = getMessageHash(_type, paymentErc20, price);
        bytes32 ethSignedmessageHash = getETHSignedMessageHash(messageHash);

        return recover(ethSignedmessageHash, _sig) == _signer;
    }

    function getMessageHash(
        uint256 _boxType,
        address _paymentErc20,
        uint256 _price
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_boxType, _paymentErc20, _price));
    }

    function getETHSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function _split(bytes memory _sig)
        internal
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(_sig.length == 65, "invalid signature length");

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(_sig, 32))
            // second 32 bytes
            s := mload(add(_sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}
