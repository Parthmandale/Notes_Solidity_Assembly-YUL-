// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

/* Use of memory in Yul
- Returns vlues from external calls.
- setting function arguments.
- setting function returns types.
- Revert with an error string.
- log messages.
- creates other smart contracts.
- use keccak256 hash function.
*/

contract YulMemoryLayout {
    struct Point {
        uint256 x;
        uint256 y;
    }

    event memoryPointer(bytes32);
    event memoryPointerV2(bytes32, bytes32);

    function readHighValue() external pure {
        assembly {
            // pop - throws away the return value. ie. remove value from stack
            pop(mload(0xffffffffffffffff))
        }
    }

    function differentMstore() external pure {
        assembly {
            mstore8(0x00, 8) // 8 in start of space
            mstore(0x00, 8) // 8 in last of space
        }
    }

    // declaring struct memory
    function structMemory() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40) // retrives 32 bytes from that slot |
        }

        emit memoryPointer(x40); // 0x0000000000000000000000000000000000000000000000000000000000000080 | becuz our action begins at slot [0x80]

        //declare struct
        Point memory p = Point({x: 1, y: 2});

        assembly {
            x40 := mload(0x40)
        }
        emit memoryPointer(x40); // 0x00000000000000000000000000000000000000000000000000000000000000c0 |
        // note if be subtact 0x00000000000000000000000000000000000000000000000000000000000000c0 - 0x0000000000000000000000000000000000000000000000000000000000000080 = 64
        // and this is 64 becuase in struct 2 values are stored at uint256 ie. they hold 32 bytes each

        // therefore the free memory pointer increases as the transaction progresses
    }

    // zero slots and [ Msize - largest access memory ]

    function zeroSlotAndMsize() external {
        bytes32 x40;
        bytes32 size;

        assembly {
            x40 := mload(0x40) // retrives 32 bytes from that slot |
            size := msize()
        }

        emit memoryPointerV2(x40, size); //"0": "0x0000000000000000000000000000000000000000000000000000000000000080", //"1": "0x0000000000000000000000000000000000000000000000000000000000000060"

        //declare struct
        Point memory p = Point({x: 1, y: 2});

        assembly {
            x40 := mload(0x40)
            size := msize()
        }
        emit memoryPointerV2(x40, size); // "0": "0x00000000000000000000000000000000000000000000000000000000000000c0", "1": "0x00000000000000000000000000000000000000000000000000000000000000c0"
    }

    // array
    function fixedArray() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit memoryPointer(x40); //0x0000000000000000000000000000000000000000000000000000000000000080

        uint256[2] memory arr = [uint256(5), uint256(6)];
        assembly {
            x40 := mload(0x40)
        }

        emit memoryPointer(x40); //0x00000000000000000000000000000000000000000000000000000000000000c0 -> this is difference of 64 bits
    }

    // abi.encode memory layout
    function abiEncode() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit memoryPointer(x40); //0x0000000000000000000000000000000000000000000000000000000000000080

        abi.encode(uint256(5), uint256(6));

        assembly {
            x40 := mload(0x40)
        }

        emit memoryPointer(x40); // 0x00000000000000000000000000000000000000000000000000000000000000e0
    }

    // abi.encodePacked memory layout
    function abiEncodePacked() external {
        bytes32 x40;
        assembly {
            x40 := mload(0x40)
        }
        emit memoryPointer(x40); //0x0000000000000000000000000000000000000000000000000000000000000080

        abi.encodePacked(uint256(5), uint128(6));

        assembly {
            x40 := mload(0x40)
        }

        emit memoryPointer(x40); // 0x00000000000000000000000000000000000000000000000000000000000000d0 | this is the difference as uint 256+128 bits
    }

    event Debug(bytes32, bytes32, bytes32, bytes32);

    // dynamic array
    function DynamicArrayValues(uint256[] memory arr) external {
        bytes32 location;
        bytes32 len;
        bytes32 valueAtIndex0;
        bytes32 valueAtIndex1;

        assembly {
            location := arr // location of array - variable name itself is where the memory actually begins
            len := mload(arr) // lenght of array
            // to access the dynamic array we have to add 32 bytes(0x20) to skip its length
            valueAtIndex0 := mload(add(arr, 0x20)) // 20 bytes got occupied here
            valueAtIndex1 := mload(add(arr, 0x40)) // therefore loading next 20 bytes

            // the more you access memory on that long array the more you will be charged gas
        }

        emit Debug(location, len, valueAtIndex0, valueAtIndex1);

        // for array -> [3,8]
        // location - 0x0000000000000000000000000000000000000000000000000000000000000080
        // len - 0x0000000000000000000000000000000000000000000000000000000000000002
        // valueAtIndex0 - 0x0000000000000000000000000000000000000000000000000000000000000003
        // valueAtIndex1 - 0x0000000000000000000000000000000000000000000000000000000000000008
    }
}
