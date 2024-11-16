// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

contract YulDataTypes {
    function getUint256() external pure returns (uint256) {
        uint256 x;

        assembly {
            x := 100
        }

        return x;
    }

    function getUintFromHex() external pure returns (uint256) {
        uint256 x;

        assembly {
            x := 0x64 //100
        }

        return x;
    }

    function getAddress() external pure returns (address) {
        address x;

        assembly {
            x := 1
        }

        return x;
    }

    function getBoolean() external pure returns (bool, bool, bool) {
        bool x;
        bool y;
        bool z;
        bytes32 zero; // no declaration

        assembly {
            x := 1 // every non zero indexed bytes32, is been interprets as true.
            y := 0
            z := zero // not initialized so it is going to be 0 indexed bytes, therfore false
        }

        return (x, y, z);
    }

    function getString() external pure returns (string memory) {
        bytes32 x; // because string are not stored in stack it is always memory, and  bytes 32 and yul are stored on stack.

        assembly {
            x := "Hello"
        }

        return string(abi.encode(x));
    }
}
