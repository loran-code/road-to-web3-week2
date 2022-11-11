//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

// Example deployed to Goerli: 0x7ae441E4fEA8d4884577cC3e0e4B7f994862E185

contract BuyMeACoffee {
    // Vars
    address payable owner;
    address payable withdrawAddress;
    Memo[] memos;  // List of time, name and message's received from coffee purchases.
    
    // Events
    event NewMemo(address indexed from, uint256 timestamp, string name, string message);

    // Structs
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // Constructor
    constructor() {
        owner = payable(msg.sender);
        withdrawAddress = owner;
    }

    // Write Functions
    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Must accept more than 0 ETH for a coffee.
        require(msg.value > 0, "Hey Cheapsky! Coffee is not free, increase the donation amount!");

        // Add the memo to storage!
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /**
    * @dev change owner address
    * @param _newAddress new address
    */
    function updateWithdrawTipsAddress(address _newAddress) public {
        require(payable(msg.sender) == owner, 'You not are the owner, you can not change the withdraw address!');
        withdrawAddress = payable(_newAddress);
  }

    /**
     * @dev send the entire balance stored in this contract to the withdraw address that is set by the owner
     */
    function withdrawTips() public {
        require(withdrawAddress.send(address(this).balance));
    }

    // View Functions
    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }
}
