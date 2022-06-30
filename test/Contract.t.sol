// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/SortedLinkedList.sol";

contract SortedLinkedListTest is Test {
    using SortedLinkedList for SortedLinkedList.Info;
    SortedLinkedList.Info linkedList;

    function setUp() public {}

    function test1_insert_head() public {
        assertLength(0);

        linkedList.insert(address(1), 2);
        assertLength(1);
        assertNodeAt(0, address(1), 2);
    }

    function test2_insert_bigger() public {
        assertLength(0);

        linkedList.insert(address(1), 2);
        assertLength(1);
        assertNodeAt(0, address(1), 2);

        linkedList.insert(address(2), 100);
        assertLength(2);
        assertNodeAt(1, address(2), 100);

        printLinkedList();
    }

    function test2_insert_same_address_bigger() public {
        assertLength(0);

        linkedList.insert(address(1), 2);
        assertLength(1);
        assertNodeAt(0, address(1), 2);

        linkedList.insert(address(1), 100);
        assertLength(1);
        assertNodeAt(0, address(1), 100);

        printLinkedList();
    }

    function test2_insert_same_address_replace_value() public {
        assertLength(0);

        linkedList.insert(address(1), 1);
        linkedList.insert(address(2), 3);
        linkedList.insert(address(3), 5);
        assertLength(3);
        assertNodeAt(0, address(1), 1);
        assertNodeAt(1, address(2), 3);
        assertNodeAt(2, address(3), 5);

        linkedList.insert(address(2), 4);
        assertNodeAt(0, address(1), 1);
        assertNodeAt(1, address(2), 4);
        assertNodeAt(2, address(3), 5);

        printLinkedList();
    }

    function test2_insert_same_address_reorder() public {
        assertLength(0);

        linkedList.insert(address(1), 1);
        linkedList.insert(address(2), 3);
        linkedList.insert(address(3), 5);
        assertLength(3);
        assertNodeAt(0, address(1), 1);
        assertNodeAt(1, address(2), 3);
        assertNodeAt(2, address(3), 5);

        linkedList.insert(address(2), 7);
        assertNodeAt(0, address(1), 1);
        assertNodeAt(1, address(3), 5);
        assertNodeAt(2, address(2), 7);

        printLinkedList();
    }

    function test3_insert_same_address_reverts() public {
        assertLength(0);

        linkedList.insert(address(1), 1);
        linkedList.insert(address(2), 3);
        linkedList.insert(address(3), 5);
        assertLength(3);

        vm.expectRevert();
        linkedList.insert(address(3), 2);
    }

    function linkedListLength() internal returns (uint256) {
        return linkedList.reduce(count, 0);
    }

    function printLinkedList() internal {
        linkedList.reduce(print, 0);
    }

    function assertLength(uint256 length) internal {
        assertTrue(linkedListLength() == length);
    }

    function assertNodeAt(
        uint256 index,
        address account,
        uint256 value
    ) internal {
        (address a, uint256 v) = getAt(index);
        assertTrue(a == account);
        assertTrue(v == value);
    }

    address _account;
    uint256 _value;

    function getAt(uint256 index)
        internal
        returns (address account, uint256 value)
    {
        linkedList.reduce(_getAt, index + 1);
        return (_account, _value);
    }

    function _getAt(
        address account,
        uint256 value,
        uint256 acc
    ) internal returns (uint256) {
        if (acc == 1) {
            _account = account;
            _value = value;
        } else if (acc > 1) {
            return --acc;
        }
        return 0;
    }

    function count(
        address,
        uint256,
        uint256 acc
    ) internal pure returns (uint256) {
        return acc + 1;
    }

    function print(
        address account,
        uint256 value,
        uint256
    ) internal view returns (uint256) {
        console2.log(account, value);
        return 0;
    }
}
