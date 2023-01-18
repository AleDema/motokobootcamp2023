import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Option "mo:base/Option";

actor {

    type ProposalId = Nat;
    type Proposal = {
        id : ProposalId;
        title : Text;
        description : Text;
        change : Text;
        state : ProposalState;
        accept_votes : Nat;
        reject_votes : Nat
    };

    type ProposalVotes = {
        votes : [var Vote]
    };

    type ProposalData = {
        proposal : Proposal;
        proposalVotes : ProposalVotes
    };

    type ProposalState = {
        #approved;
        #rejected;
        #open
    };

    type VotingOptions = {
        #approve;
        #reject
    };

    type Vote = {
        voter : Principal;
        voting_power : Nat;
        vote : VotingOptions
    };

    let proposals = Buffer.Buffer<Proposal>(100);
    //struct for neurons, hashmap? <Principal, Buffer.Buffer<Neuron>>
    //struct for user balances?  <Principal, Nat>

    public func submit_proposal(title : Text, description : Text, change : Text) : async () {
        let p : Proposal = {
            id = proposals.size();
            title = title;
            description = description;
            change = change;
            accept_votes = 0;
            reject_votes = 0;
            state = #open
        };
        proposals.add(p)
    };

    public query func get_proposal(id : ProposalId) : async Result.Result<Proposal, Text> {
        switch (proposals.getOpt(id)) {
            case (null) {
                return #err("no proposal")
            };
            case (?proposal) {
                return #ok(proposal)
            }
        }
    };

    public query func get_all_proposals() : async [Proposal] {
        Buffer.toArray(proposals)
    };

    public shared (caller) func vote(p : Proposal) : async () {

    };

    private func verify_balance(caller : Principal) : async Nat {
        return 10; //TEMP
    }

}
