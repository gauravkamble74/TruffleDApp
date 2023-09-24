// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsuranceClaimContract {


        uint256 a;

    function setter(uint256 _a) public {
        a = _a;
    }

    function getter() public view returns (uint256) {
        return a;
    }

    struct InsuranceClaim {
        string id;
        string claimant;
        int claimAmount;
        string status;
        string policyID;
        string coverageType;
    }

    struct Policy {
        string policyID;
        string coverageType;
        uint256 coverageLimit;
    }

    mapping(string => Policy) public policies;
    mapping(string => InsuranceClaim) public insuranceClaims;

    event ClaimCreated(string id, string claimant, int claimAmount, string status, string policyID, string coverageType);
    event ClaimApproved(string claimID, string message);
    event ClaimRejected(string claimID, string reason);

    constructor() {
        // Initialize policies
        policies["POLICY001"] = Policy("POLICY001", "Health Insurance", 100000);
        policies["POLICY002"] = Policy("POLICY002", "Auto Insurance", 50000);
        policies["POLICY003"] = Policy("POLICY003", "Auto Insurance", 60000);
    }

    function createClaim(
        string memory id,
        string memory claimant,
        int claimAmount,
        string memory policyID,
        string memory coverageType
    ) public {
        require(bytes(id).length > 0, "Claim ID must not be empty");
        require(bytes(claimant).length > 0, "Claimant must not be empty");
        require(claimAmount > 0, "Claim amount must be greater than zero");
        require(bytes(policyID).length > 0, "Policy ID must not be empty");
        require(bytes(coverageType).length > 0, "Coverage type must not be empty");
        require(policies[policyID].coverageLimit >= uint256(claimAmount), "Claim amount exceeds policy coverage limit");

        insuranceClaims[id] = InsuranceClaim(id, claimant, claimAmount, "Pending", policyID, coverageType);
        emit ClaimCreated(id, claimant, claimAmount, "Pending", policyID, coverageType);
    }

    function approveClaim(string memory claimID) public {
        InsuranceClaim storage claim = insuranceClaims[claimID];
        require(bytes(claim.id).length > 0, "Claim with this ID does not exist");
        require(keccak256(bytes(claim.status)) == keccak256("Pending"), "Claim is not in pending status");
        require(keccak256(bytes(claim.policyID)) == keccak256(abi.encode(policies[claim.policyID].coverageType)), "Policy mismatch");

        claim.status = "Approved";
        emit ClaimApproved(claim.id, "Claim has been approved");
    }

    function rejectClaim(string memory claimID, string memory reason) public {
        InsuranceClaim storage claim = insuranceClaims[claimID];
        require(bytes(claim.id).length > 0, "Claim with this ID does not exist");
        require(keccak256(bytes(claim.status)) == keccak256("Pending"), "Claim is not in pending status");

        claim.status = "Rejected";
        emit ClaimRejected(claim.id, reason);
    }

    function getClaimStatus(string memory claimID) public view returns (string memory) {
        InsuranceClaim storage claim = insuranceClaims[claimID];
        require(bytes(claim.id).length > 0, "Claim with this ID does not exist");
        return claim.status;
    }
}
