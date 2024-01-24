const fs = require('fs');

async function main() {
  const NFTMarket = await ethers.getContractFactory("Staking");
  const nftMarket = await NFTMarket.deploy();
  await nftMarket.deployed();
  console.log("Staking contract deployed to:", nftMarket.address);

  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy(nftMarket.address);
  await nft.deployed();
  console.log("Reward Toke contract deployed to:", nft.address);

  const config = `
  export const nftmarketaddress = "${nftMarket.address}";
  export const nftaddress = "${nft.address}";`;

  fs.writeFileSync('config.js', config);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });