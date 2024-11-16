// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

contract basicOperation {
    // a+b
    function Add(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := add(a, b)
        }
    }

    // a-b
    function Sub(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := sub(a, b)
        }
    }

    // a/b, if the  num is greater than deno, then it going to retiurn 0, also when deno is 0 then also retrn 0
    function Div(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := div(a, b)
        }
    }

    // a*b
    function Mul(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := mul(a, b)
        }
    }

    // a<b | lt means that left side is smaller(only smaller neither equal to) then we win and return 1 otherwise 0
    function checkLeftSide(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := lt(a, b)
        }
    }

    // gives proper modulo in number and not like 0 or 1
    function modulo(uint256 a, uint256 b) external pure returns (uint256 c) {
        assembly {
            c := mod(a, b)
        }
    }

    function checkZero(uint256 a) external pure returns (uint256 c) {
        assembly {
            c := iszero(a) // if 0 then returns 1 that represents true, otherwise returns 0 that represents false
        }
    }

    function checkZeroBytes32(uint256 a) external pure returns (bytes32 c) {
        assembly {
            c := iszero(a)
        }
    }

    // if all bits 0 then if condition won't get executed | in order to get into if condition atleast one bit must be non zero
    function isTruthy() external pure returns (uint256 result) {
        result = 2;
        assembly {
            if 2 {
                // where all the bits inside bytes32 is NOT zero (in 2 it is like 0x000...2, so meaning not all are 0 bits) == true
                result := 1
            }
        }
    }

    // if all bits 0 then if condition won't get executed | in order to get into if condition atleast one bit must be non zero
    function isFalse() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if 0 {
                // where all the bits inside bytes32 is zero == false
                result := 2
            }
        }
    }

    function negation() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if iszero(0) {
                // only executed when all bits are 0.
                result := 2
            }
        }
        return result;
    }

    function max(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            // executes only if a strictly is smaller than b // ie, returns 1
            if lt(a, b) { result := b }

            // executes only if lt(a,b) returns 0, ie. a is not smaller than b(a is bigger) // ie, returns 1
            if iszero(lt(a, b)) { result := a }
        }
    }

    function checkSwitch(uint256 a, uint256 b) external pure returns (uint256 smaller) {
        uint256 sum;

        assembly {
            sum := add(a, b)

            switch lt(a, b)
            case true { smaller := a }
            case false { smaller := b }
            default { smaller := sum }
        }
    }

    // no while loop in assembly
    // so we write for loop in such a way that ift behaves like while loops
    function whileLoop() external pure returns (uint256 result) {
        assembly {
            // initialize | condition | post-iteration
            for { let i := 0 } lt(i, 10) { i := add(i, 1) } {
                // while(i < 10)
                result := add(result, i)
            }
        }
    }

    function isPrime(uint256 x) public pure returns (bool result) {
        result = true;

        assembly {
            let halfX := add(div(x, 2), 1)

            for { let i := 2 } lt(i, halfX) { i := add(i, 1) } {
                if iszero(mod(x, i)) {
                    result := 0
                    break
                }
            }
        }
    }
}
