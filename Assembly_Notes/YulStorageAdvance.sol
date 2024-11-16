// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

contract YulStorage {
    //NOTE -> 1 byte = 8 bits, 1 byte = 2 hexadecimal number and 1 hexadecimal = 4 bits

    //  256 bit = 32 bytes
    // multiple variable are sequentially arranged and sum of all the variable are less than or equal to 32 bytes
    uint128 public A = 1; // 16 bytes
    uint96 public B = 2; // 12 bytes
    uint16 public C = 4; // 2 bytes
    uint8 public D = 5; // 1 bytes
    bool public E = true; // 1 bytes

    function loadYulSlotInBytes(uint256 slot) external view returns (bytes32 ret) {
        assembly {
            ret := sload(slot) // should return "value" of that perticular slot number | but here yul is giving offset
        }
    }

    function getOffsetC() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := C.slot
            offset := C.offset //returns 28 because this tells that 28 bytes are acually there stored before the C var comes, ie. A & B is holding 16+12 bytes
        }
    }

    function readVariableC() external view returns (uint16 ret) {
        assembly {
            let slot := sload(C.slot)
            // 0x0105000400000000000000000000000200000000000000000000000000000001

            let offset := C.offset //28

            // shifting to the right | shr(x, y) - logical shift right y by x bits
            // we know 1 bytes == 8 bits , therefore we mul here
            ret := shr(mul(offset, 8), slot) // will only work when return type is uint16
                // in bytes => 0x0000000000000000000000020000000000000000000000000000000101050004 | in uint - 4

            // to work when return type is uint256
            // ret := and(0xffff, ret)
        }
    }

    // changing storage value in yul
    function changeValInYul(uint256 slot, uint256 value) external {
        /* from this we are only able to change slot 0 ie. A value and not ablr to do update slot 1,2,3,4  |
    To solve this problem we are going to use BIT MASKING and BIT SHIFTING | see the next function updateSlotC
        */
        assembly {
            sstore(slot, value)
        }
    }

    //  function updateSlotC(uint256 value) external {
    //     assembly {
    // example we are updating the c value from 4 to 9, therefor value = 9 = in bytes32  0x0000000000000000000000000000000000000000000000000000000000000008

    //         let loadC := sload(C.slot) // slot 0

    //         let clearedC := and(loadC, )
    //     }
    //  }

    // function uintToBytes(uint256 value) external pure returns(bytes32 ret) {
    // ret = bytes32(value);
    // return ret;
    // }
}
