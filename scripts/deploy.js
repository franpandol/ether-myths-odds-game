async function main() {
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }

  const { ethers } = require("hardhat");

  const [deployer] = await ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );


  const Betting = await ethers.getContractFactory("Betting");
  const bettingsContract = await Betting.deploy();
  const address = await  bettingsContract.waitForDeployment();  

  saveFrontendFiles(await address.getAddress());
  // We also save the contract's artifacts and addresses in the frontend directory
  saveFrontendFiles(await address.getAddress(), __dirname + "/../frontend/src/contracts_build");

}

function saveFrontendFiles(address, contractsDir=null) {
  const fs = require("fs");
  if (!contractsDir) {
    contractsDir = __dirname + "/../contracts_build";
  }

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

  fs.writeFileSync(
    contractsDir + "/contract-address.json",
    JSON.stringify({ Betting: address}, undefined, 2)
  );

  const BettingsArtifact = artifacts.readArtifactSync("Betting");

  fs.writeFileSync(
    contractsDir + "/Betting.json",
    JSON.stringify(BettingsArtifact, null, 2)
  );
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
