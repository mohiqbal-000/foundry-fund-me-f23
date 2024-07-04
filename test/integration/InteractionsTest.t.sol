// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";
import {FundMe} from "../../src/FundMe.sol";

import {Test, console} from "forge-std/Test.sol";

contract Interactions is Test {
    FundMe fundMe;
   
    address USER = makeAddr("user"); // Renamed to avoid conflict

    uint256 public constant SEND_VALUE = 0.5 ether; // just a value to make sure we are sending enough!
    uint256 public constant STARTING_USER_BALANCE = 20 ether;
    uint256 public constant GAS_PRICE = 1;

    address public constant CONSTANT_USER = address(1); // Renamed to avoid conflict

    // uint256 public constant SEND_VALUE = 1e18;
    // uint256 public constant SEND_VALUE = 1_000_000_000_000_000_000;
    // uint256 public constant SEND_VALUE = 1000000000000000000;
    function fund() public payable {
    require(msg.value > 0, "No value sent");
    // Log the current balance of the contract
    console.log("Current balance:", address(this).balance);
    // Update the contract's state with the received funds
    // ...
}


   function setUp() external {
    DeployFundMe deploy = new DeployFundMe();
    fundMe = deploy.run();
    // Allocate Ether to the FundMe contract
    vm.deal(address(fundMe), STARTING_USER_BALANCE);
}

    function testUserCanFundInteractions() public {
    // Assuming vm.deal is used to allocate funds to the user
    vm.deal(address(fundMe), 20 * 10**18);

    // Directly interact with the contract without using prank
    FundFundMe fundFundMe = new FundFundMe();
    fundFundMe.fundFundMe(address(fundMe));

    // Check the funder
    address funder = fundMe.getFunders(0);
    assertEq(funder, USER); // Ensure the correct user is identified as the funder

    // Proceed with withdrawal
    WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
    withdrawFundMe.withdrawFundMe(address(fundMe));

    // Assert that the contract balance is now zero
    assert(address(fundMe).balance == 0);
}

}
