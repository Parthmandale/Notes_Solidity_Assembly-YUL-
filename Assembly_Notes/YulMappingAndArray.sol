// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

contract YulMappingAndArray {
    uint256[3] fixedLengthArray;
    uint256[] dynamicArray;

    mapping(uint256 => uint256) private myMapping;
    mapping(uint256 => mapping(uint256 => uint256)) private myNestedMapping;

    constructor() {
        fixedLengthArray = [5, 10, 15];
        dynamicArray = [4, 6, 8, 7];

        myMapping[1] = 100;
        myNestedMapping[1][2] = 1000;
    }

    // fixed
    function readFixedArray(uint256 index) external view returns (uint256 ret) {
        assembly {
            let slot := fixedLengthArray.slot //starting from 0
            ret := sload(add(slot, index))
        }
    }

    // update the storage in fixed array in yul
    function writeToFixedArrayinYul(uint256 index, uint256 value) external {
        assembly {
            let slot := fixedLengthArray.slot
            sstore(add(slot, index), value)
        }
    }

    // dynamic
    function dynamicArrayLength() external view returns (uint256 ret) {
        /* in EVM for fixed len array slot are going to arraged sequentially but here for dynamic len slot are not arranged 
    in sequence and therefore here below this will work as to define the length of dynamic array | because dynamic array can 
    be updated anytime so we make sure they don't crash with other slot*/
        assembly {
            ret := sload(dynamicArray.slot)
        }
    }

    // reading the location of dynamic array
    function readDynamicArrayLocation(uint256 index) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := dynamicArray.slot //returns 3 because before that fixed array slots are coming
        }

        bytes32 location = keccak256(abi.encode(slot)); // converting uint 3 - bytes32

        assembly {
            ret := sload(add(location, index))
        }
    }

    function getMappingValue(uint256 key) external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := myMapping.slot
        }

        // concatinating key and the slot | as the key changes the storage locationa also changes
        bytes32 location = keccak256(abi.encode(key, uint256(slot)));

        assembly {
            ret := sload(location)
        }
    }

    function getNestedMappingValue() external view returns (uint256 ret) {
        uint256 slot;
        assembly {
            slot := myNestedMapping.slot
        }

        // concatinating the hashes of 1st and 2nd key and the slot |
        bytes32 location = keccak256(abi.encode(uint256(2), keccak256(abi.encode(uint256(1), uint256(slot)))));

        assembly {
            ret := sload(location)
        }
    }
}
