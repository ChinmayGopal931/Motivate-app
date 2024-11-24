// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/**
 * @title DoIt Contract
 * @dev A smart contract for creating and managing promises with financial stakes
 * Users can create promises, stake MATIC, and have friends verify completion
 */
contract DoIt {
    // Represents a single promise with its associated details and state
    struct Promise {
        uint256 promiseId; // Unique identifier for the promise
        string promiseTask; // Description of what needs to be done
        uint256 promiseAmount; // Amount of MATIC staked
        address payable creator; // Address of the person making the promise
        address payable friend; // Address of the verifier
        uint256 endTime; // Deadline timestamp
        bool isFulfilled; // Tracks whether promise is completed
    }

    // Tracks user's promises and associated data
    struct User {
        uint256 lockedFunds; // Total MATIC locked in active promises
        uint256[] userPromisesList; // List of promises created by user
        uint256[] promisesToBeFulfilledByUserList; // List of promises user needs to verify
        // Maps promise ID to its index in userPromisesList for O(1) access
        mapping(uint256 => uint256) userPromisesListMapping;
        // Maps promise ID to its index in promisesToBeFulfilledByUserList for O(1) access
        mapping(uint256 => uint256) promisesToBeFulfilledByUserListMapping;
    }

    // Array of all promises ever created
    Promise[] promises;

    // Maps user addresses to their User struct
    mapping(address => User) users;

    // Events for frontend updates and blockchain tracking
    event PromiseCreated(string promiseTask, uint256 promiseAmount, address payable friend, uint256 id);
    event PromiseFulfilled(address fulfiller, address fundReceiver);

    // Contract owner address (can claim stakes after deadlines)
    address owner;

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Returns the total amount of MATIC locked in user's active promises
     * @return uint256 Amount of locked funds
     */
    function getlockedFunds() external view returns (uint256) {
        return users[msg.sender].lockedFunds;
    }

    /**
     * @dev Returns details of a specific promise
     * @param id The ID of the promise to query
     * @return Promise struct containing promise details
     */
    function getPendingPromise(uint256 id) external view returns (Promise memory) {
        return promises[id];
    }

    /**
     * @dev Returns array of promise IDs created by the caller
     * @return uint256[] Array of promise IDs
     */
    function getPendingPromises() external view returns (uint256[] memory) {
        return users[msg.sender].userPromisesList;
    }

    /**
     * @dev Returns array of promise IDs that caller needs to verify
     * @return uint256[] Array of promise IDs
     */
    function getPromisesToBeFulfilled() external view returns (uint256[] memory) {
        return users[msg.sender].promisesToBeFulfilledByUserList;
    }

    /**
     * @dev Creates a new promise with financial stake
     * @param promiseTask Description of the task to be completed
     * @param promiseAmount Amount of MATIC to stake
     * @param friend Address of verifier
     * @param endTime Deadline timestamp
     */
    function createPromise(string calldata promiseTask, uint256 promiseAmount, address payable friend, uint256 endTime)
        external
        payable
    {
        // Verify correct amount was sent
        require(msg.value == promiseAmount, "Please send the correct amount of funds.");

        // Create and store new promise
        promises.push(Promise(promises.length, promiseTask, promiseAmount, payable(msg.sender), friend, endTime, false));
        uint256 id = promises.length - 1;

        // Update creator's records
        users[msg.sender].userPromisesList.push(id);
        users[msg.sender].userPromisesListMapping[id] = users[msg.sender].userPromisesList.length - 1;
        users[msg.sender].lockedFunds += promiseAmount;

        // Update friend's records
        users[friend].promisesToBeFulfilledByUserList.push(id);
        users[friend].promisesToBeFulfilledByUserListMapping[id] =
            users[friend].promisesToBeFulfilledByUserList.length - 1;

        emit PromiseCreated(promiseTask, promiseAmount, friend, id);
    }

    /**
     * @dev Fulfills a promise and handles fund distribution
     * @param id The ID of the promise to fulfill
     * @return bool Success status
     */
    function fulfillPromise(uint256 id) external returns (bool) {
        // Verify fulfillment conditions
        require(
            block.timestamp >= promises[id].endTime || msg.sender != owner,
            "Owner of dapp cannot fulfill promise before endTime"
        );
        require(
            msg.sender == promises[id].friend || msg.sender == owner,
            "Only the friend or owner of dapp can fulfill promise"
        );

        uint256 transferAmount = promises[id].promiseAmount;
        address creator = promises[id].creator;

        // Update creator's records
        uint256 idOfCreatorList = users[creator].userPromisesListMapping[id];
        delete users[creator].userPromisesListMapping[id];
        users[creator].userPromisesList[idOfCreatorList] =
            users[creator].userPromisesList[users[creator].userPromisesList.length - 1];
        users[creator].userPromisesListMapping[users[creator].userPromisesList[idOfCreatorList]] = idOfCreatorList;
        users[creator].lockedFunds -= transferAmount;
        users[creator].userPromisesList.pop();

        // Update friend's records
        address friend = msg.sender;
        uint256 idOfFriendList = users[friend].promisesToBeFulfilledByUserListMapping[id];
        delete users[friend].promisesToBeFulfilledByUserListMapping[id];
        users[friend].promisesToBeFulfilledByUserList[idOfFriendList] =
            users[friend].promisesToBeFulfilledByUserList[users[friend].promisesToBeFulfilledByUserList.length - 1];
        users[friend].promisesToBeFulfilledByUserListMapping[users[friend].promisesToBeFulfilledByUserList[idOfFriendList]]
        = idOfFriendList;
        users[friend].promisesToBeFulfilledByUserList.pop();

        // Transfer funds based on who fulfilled
        if (msg.sender == owner) {
            payable(owner).transfer(transferAmount); // Deadline passed, owner claims stake
        } else {
            payable(creator).transfer(transferAmount); // Promise completed, return stake to creator
        }

        promises[id].isFulfilled = true;

        // Emit appropriate event
        if (msg.sender != owner) {
            emit PromiseFulfilled(friend, creator);
        } else {
            emit PromiseFulfilled(owner, owner);
        }
        return true;
    }

    /**
     * @dev Returns all promises created by caller (alias for getPendingPromises)
     * @return uint256[] Array of promise IDs
     */
    function getPromises() external view returns (uint256[] memory) {
        return users[msg.sender].userPromisesList;
    }
}
