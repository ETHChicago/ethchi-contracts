const { ethers } = require("ethers");
const zoraErc721DropABI = require("../abis/zora-erc721-drop-abi.json");
const fs = require('fs');
require("dotenv").config();


const ethereum_rpc = process.env.MAINNET_RPC_URL;
console.log(`Ethereum RPC: ${ethereum_rpc}\n`);
const provider = new ethers.InfuraProvider("mainnet", process.env.INFURA_API_KEY);
console.log(`Provider: ${JSON.stringify(provider)}\n`);

async function main() {
    const uniqueEthchiSupporterOwners = await getEthchiSupporterOwners();
    const uniqueEthchiTeamOwners = await getEthchiTeamOwners();

    const allUniqueOwners = [...new Set([...uniqueEthchiSupporterOwners, ...uniqueEthchiTeamOwners])];

    // write all owners to file for later use
    fs.writeFileSync('data/holiday-airdrop-recipients.json', JSON.stringify(allUniqueOwners));
}

async function getEthchiSupporterOwners() {
    const ethchiSupporterAddress = "0xDd4261fDF8a5bD581D9C1564f02eb7C0d7bc548e";
    const ethchiSupporterContract = new ethers.Contract(
        ethchiSupporterAddress, 
        zoraErc721DropABI, 
        provider
    );

    const name = await ethchiSupporterContract.name();
    console.log(`Name: ${name}\n`);
    const totalSupply = await ethchiSupporterContract.totalSupply();
    //console.log(`Total Supply: ${totalSupply}\n`);

    const owners = [];
    console.log(`Getting ${name} owners...`)
    for (let i = 1; i <= totalSupply; i++) {
        const owner = await ethchiSupporterContract.ownerOf(i);
        //console.log(`Token ID: ${i} - Owner: ${owner}`);
        owners.push(owner);
    }
    const uniqueOwners = [...new Set(owners)];
    console.log(`Got unique ${name} owners: ${uniqueOwners.length}`);

    return uniqueOwners;
}

async function getEthchiTeamOwners() {
    const ethchiTeamAddress = "0xEfeD2f614f0e691CC77Cd84f7BB6da46a237d1d7";
    const ethchiTeamContract = new ethers.Contract(
        ethchiTeamAddress, 
        zoraErc721DropABI, 
        provider
    );

    const name = await ethchiTeamContract.name();
    console.log(`Name: ${name}\n`);
    const totalSupply = await ethchiTeamContract.totalSupply();

    const owners = [];
    console.log(`Getting ${name} owners...`)
    for (let i = 1; i <= totalSupply; i++) {
        const owner = await ethchiTeamContract.ownerOf(i);
        //console.log(`Token ID: ${i} - Owner: ${owner}`);
        owners.push(owner);
    }
    const uniqueOwners = [...new Set(owners)];
    console.log(`Got unique ${name} owners: ${uniqueOwners.length}`);

    return uniqueOwners;
}


main()