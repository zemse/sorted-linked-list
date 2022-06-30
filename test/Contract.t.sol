// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/SortedLinkedList.sol";

contract SortedLinkedListTest is Test {
    using SortedLinkedList for SortedLinkedList.Info;
    SortedLinkedList.Info linkedList;

    function setUp() public {}

    function test1_insert_head() public {
        assertTrue(linkedListLength() == 0);
        linkedList.insert(address(1), 2);
        assertTrue(linkedListLength() == 1);
        printLinkedList();
    }

    function test2_insert_bigger() public {
        assertTrue(linkedListLength() == 0);
        linkedList.insert(address(1), 2);
        assertTrue(linkedListLength() == 1);
        linkedList.insert(address(2), 100);
        assertTrue(linkedListLength() == 2);
        printLinkedList();
    }

    function test2_insert_same_address_reverts() public {
        linkedList.insert(address(1), 2);
        vm.expectRevert();
        linkedList.insert(address(1), 100);
    }

    function test3_insert_same_address_reverts() public {
        linkedList.insert(address(1), 1);
        linkedList.insert(address(2), 3);
        linkedList.insert(address(3), 5);
        vm.expectRevert();
        linkedList.insert(address(3), 2);
    }

    function linkedListLength() internal returns (uint256) {
        return linkedList.reduce(count, 0);
    }

    function printLinkedList() internal {
        linkedList.reduce(print, 0);
    }

    function count(uint256, uint256 acc) internal pure returns (uint256) {
        return acc + 1;
    }

    function print(uint256 value, uint256) internal view returns (uint256) {
        console2.log(value);
        return 0;
    }
}
