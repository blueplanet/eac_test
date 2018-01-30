var DelayedPayment = artifacts.require("./DelayedPayment.sol");

module.exports = function(deployer) {
  deployer.deploy(DelayedPayment, "0xAA1D2F8f24C780999AE694591BD09BCfd9accc56", 40);
};
