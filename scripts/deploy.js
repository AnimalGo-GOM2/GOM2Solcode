const hardhat = require('hardhat');

async function main() {
    console.log("Deployment stared...")

    const GOM = await hardhat.ethers.getContractFactory('GoMoney2');

    const gom = await GOM.deploy();

    console.log(`===== GoMoney2 Contract Deployed at address: ${gom.address} ======`);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
