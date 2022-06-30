// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library SortedLinkedList {
    using SortedLinkedList for SortedLinkedList.Info;

    address constant NULL = address(0);

    struct Info {
        mapping(address => Node) nodes;
    }

    struct Node {
        // address account;
        uint256 value;
        address nextId;
    }

    error AccountIsNull();
    error AccountExists();

    function insert(
        SortedLinkedList.Info storage linkedList,
        address account,
        uint256 value
    ) internal {
        if (account == NULL) revert AccountIsNull();

        // node that contains the head
        Node storage previous = linkedList.get(NULL);

        address currentId = previous.nextId; // head
        Node storage current = linkedList.get(currentId);

        while (true) {
            // if we reach the end, then insert here
            if (currentId == NULL) {
                previous.nextId = linkedList.createNode(account, value, NULL);
                return;
            }

            // if account already exists then revert
            if (currentId == account) {
                revert();
            }

            // find a node such that the value currently at the node is greater than input value.
            if (current.value > value) {
                // insert before the current node only if its not present in linked list
                linkedList.ensureAccountDoesNotExist(account, current.nextId);
                previous.nextId = linkedList.createNode(
                    account,
                    value,
                    currentId
                );
                return;
            }

            // continue to next node
            previous = current;
            current = linkedList.get(currentId = current.nextId);
        }
    }

    function createNode(
        SortedLinkedList.Info storage linkedList,
        address account,
        uint256 value,
        address next
    ) internal returns (address nodeId) {
        linkedList.nodes[account] = Node(value, next);
        return account;
    }

    function get(SortedLinkedList.Info storage linkedList, address account)
        internal
        view
        returns (Node storage node)
    {
        return linkedList.nodes[account];
    }

    function ensureAccountDoesNotExist(
        SortedLinkedList.Info storage linkedList,
        address account,
        address currentId
    ) internal view {
        while (true) {
            // if we reach the end, stop here
            if (currentId == NULL) {
                return;
            }

            // if we found there's already a node that's present, then revert
            if (currentId == account) {
                revert();
            }

            // continue to next node
            currentId = linkedList.get(currentId).nextId;
        }
    }

    function reduce(
        SortedLinkedList.Info storage linkedList,
        function(uint256, uint256) returns (uint256) fn,
        uint256 accumulator
    ) internal returns (uint256) {
        address currentId = linkedList.get(NULL).nextId;
        while (true) {
            // if we reach the end, stop here
            if (currentId == NULL) {
                break;
            }

            Node storage current = linkedList.get(currentId);

            accumulator = fn(current.value, accumulator);

            // continue to next node
            currentId = current.nextId;
        }
        return accumulator;
    }
}
