var DelayedPayment = artifacts.require("./DelayedPayment.sol");

module.exports = function(deployer) {
  deployer.deploy(DelayedPayment);
};
