var InsuranceClaimContract = artifacts.require("./InsuranceClaimContract.sol");

module.exports = function (deployer) {
  deployer.deploy(InsuranceClaimContract);
};

