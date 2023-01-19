import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Trie "mo:base/Trie";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Webpage "canister:Webpage";
import G "./GovernanceTypes";
// import Map "mo:hashmap/Map";
import Map "../utils/Map";

actor {

    type ProposalId = G.ProposalId;
    type Proposal = G.Proposal;
    type ProposalType = G.ProposalType;
    type ProposalState = G.ProposalState;
    type VotingOptions = G.VotingOptions;
    type Vote = G.Vote;

    stable var MIN_VP_REQUIRED = 1;
    stable var PROPOSAL_VP_THESHOLD = 100;
    stable var IS_QUADRATIC = false;
    private stable var proposal_id_counter = 0;
    let { ihash; nhash; thash; phash; calcHash } = Map;
    private stable let proposals = Map.new<Nat, Proposal>();
    //struct for neurons, hashmap? <Principal, Buffer.Buffer<Neuron>>
    //struct for user balances?  <Principal, Nat>
    //struct for user votes?  <Principal, Map<id, vote>>

    public shared (msg) func submit_proposal(title : Text, description : Text, change : Text) : async () {
        if (verify_balance(msg.caller) < MIN_VP_REQUIRED) return;

        let p : Proposal = {
            id = proposal_id_counter;
            title = title;
            description = description;
            change = change;
            approve_votes = 0;
            reject_votes = 0;
            state = #open
        };
        ignore Map.put(proposals, nhash, p.id, p);
        Debug.print("CREATED PROPOSAL");
        proposal_id_counter := proposal_id_counter +1
    };

    public query func get_proposal(id : ProposalId) : async Result.Result<Proposal, Text> {
        switch (Map.get(proposals, nhash, id)) {
            case (null) {
                return #err("no proposal")
            };
            case (?proposal) {
                return #ok(proposal)
            }
        }
    };

    public query func get_all_proposals() : async [Proposal] {
        //Debug.print(debug_show (Map.toArray(proposals)));
        let iter = Map.vals<Nat, Proposal>(proposals);
        Iter.toArray(iter)
    };

    public shared ({ caller }) func vote(id : ProposalId, choice : VotingOptions) : async () {

        Debug.print("vote");
        Debug.print(debug_show (id));
        Debug.print(debug_show (choice));
        //check if already voted? TODO

        //check balance TODO
        let user_vp = verify_balance(caller);
        if (user_vp <= MIN_VP_REQUIRED) return;

        let p : Proposal = do {
            switch (Map.get(proposals, nhash, id)) {
                case (?proposal) proposal;
                case (_) return
            }
        };
        //if approved or rejectedcan't vote' TODO
        if (p.state == #approved or p.state == #rejected) return;

        var state = p.state;
        var approve_votes = p.approve_votes;
        var reject_votes = p.reject_votes;
        switch choice {
            case (#approve) {
                if (p.approve_votes + user_vp >= PROPOSAL_VP_THESHOLD) {
                    state := #approved
                };
                approve_votes := p.approve_votes + user_vp
            };
            case (#reject) {
                Debug.print("reject");
                if (p.reject_votes + user_vp >= PROPOSAL_VP_THESHOLD) {
                    state := #rejected
                };
                reject_votes := p.reject_votes + user_vp
            }
        };

        let updated_p = {
            p with state = state;
            reject_votes = reject_votes;
            approve_votes = approve_votes
        };

        ignore Map.put(proposals, nhash, p.id, updated_p);
        Debug.print(debug_show (Map.get(proposals, nhash, id)));
        if (state == #approved) await execute_change(p.change);

    };

    //TODO actually implement this
    private func verify_balance(user : Principal) : Nat {
        return 10; //TEMP
    };

    private func execute_change(change : Text) : async () {
        //TODO
        ignore Webpage.update_body(change)
    }

    //advanced

    // modify_parameters
    // quadratic_voting
    // createNeuron
    // dissolveNeuron

}
