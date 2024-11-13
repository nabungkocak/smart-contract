const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Kocak", () => {
    const deployToken = async () => {
        const ERC20 = await ethers.getContractFactory("ERC20");
        const erc20 = await ERC20.deploy();
        return erc20;
    }

    const deployKocak = async (account, token) => {
        const Kocak = await ethers.getContractFactory("Kocak");
        const kocak = await Kocak.deploy(account, token, BigInt(1000) * BigInt(10 ** 18));
        return kocak;
    }

    it("Simple test", async () => {
        const [account1] = await ethers.getSigners();
        const token = await deployToken();
        const kocak = await deployKocak(account1, token);
        expect(await kocak.balance(), "balance must 0").to.equal(0);

        let amount = BigInt(500) * BigInt(10 ** 18);
        await token.transfer(kocak, amount);
        expect(await kocak.balance(), "balance must not 0").to.equal(amount);

        await expect(kocak.withdraw()).to.be.revertedWith('Target not reached');
        await token.transfer(kocak, amount);
        await kocak.withdraw();

        expect(await kocak.balance(), "balance must 0").to.equal(0);
        expect(await token.balanceOf(account1), "balance must same as supply").to.equal(await token.totalSupply());
    })
})