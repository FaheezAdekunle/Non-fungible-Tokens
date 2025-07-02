// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";
import {BasicNft} from "src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;

    address public bob = makeAddr("BOB");

    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        (basicNft) = deployer.run();
    }

    function testSafeMintFunctions() public {
        // Arrange
        vm.prank(bob);

        // Act
        basicNft.mintNft(PUG);

        // Assert
        assertEq(basicNft.balanceOf(bob), 1);
        assertEq(basicNft.ownerOf(0), bob);
        assertEq(basicNft.tokenURI(0), PUG);
    }

    function testTokenCounterIncreasesAfterMinting() public {
        // Arrange
        uint256 startTokenCounter = basicNft.getTokenCounter();
        vm.prank(bob);

        // Act
        basicNft.mintNft(PUG);

        // Assert
        uint256 newCounter = basicNft.getTokenCounter();
        assertEq(newCounter, startTokenCounter + 1);
    }

    function testBasicNftOwner() public {
        // Arrange
        vm.prank(bob);

        // Act / Assert
        basicNft.mintNft(PUG);
        address owner = basicNft.ownerOf(0);
        assertEq(owner, bob);
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();
        //
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveBalance() public {
        // Arrange
        vm.prank(bob);

        // Act
        basicNft.mintNft(PUG);

        // Assert
        assertEq(basicNft.balanceOf(bob), 1);
        assertEq(basicNft.ownerOf(0), bob);
    }

    function testMintNftOnContract() public {
        // Arrange
        vm.prank(contractAd);
        basicNft.mintNft(PUG);

        // Act / Assert

    }
}
