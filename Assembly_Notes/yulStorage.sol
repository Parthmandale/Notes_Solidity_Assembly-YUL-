// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// how storage variable is handled in yul -
// sload(slot)
// sstore(slot, value)
// (variableName).slot -> gives that slot number to where that storage variable is stored

contract YulStorage {
    /*slots on evm actually arranged sequentially*/
    uint256 public x = 5; // stored at 0
    uint256 public y = 10; // stored at 1
    uint256 public z = 3; // stored at 2

    function setx(uint256 newx) external {
        x = newx;
    }

    function get_storage_X_in_Yul() external view returns (uint256 ret) {
        assembly {
            /*ret := x.slot // slot will actually reference the memory location where x is actually stored,
            this will actuually not point to the x we declared in storage */

            // to point that x storage value in yul, we will have to -> sload, which is off code
            ret := sload(x.slot)
        }
    }

    function getSlot(uint256 _slot) public view returns (uint256 ret) {
        assembly {
            ret := sload(_slot) // here _slot input can be only 0,1,2 because in storage that many slots are only declared by us, and it will return corresponding stored value to it
        }
    }

    function getXSlot() external pure returns (uint256 ret) {
        assembly {
            ret := x.slot // stored at 0
        }
    }

    function getYSlot() external pure returns (uint256 ret) {
        assembly {
            ret := y.slot // stored at 1
        }
    }

    function getZSlot() external pure returns (uint256 ret) {
        assembly {
            ret := z.slot // stored at 2
        }
    }

    // updating storage value in yul: sstore - it takes two param, 1st it takes the slot number that needs to be updtaed
    // 2nd it takes the "value" to which that slot sis needed to be updated.
    function updateStorageVariableInYul(uint256 _slot, uint256 value) public {
        assembly {
            sstore(_slot, value)
        }
    }
}
