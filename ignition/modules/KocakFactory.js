const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Kocak", (m) => {
  const kocak = m.contract("KocakFactory", [process.env.OWNER, 0]);

  return { kocak };
});
