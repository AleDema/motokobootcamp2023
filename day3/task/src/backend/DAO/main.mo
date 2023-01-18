import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
// import Webpage "Webpage";

actor {

    type ProposalId = Nat;
    type Proposal = {
        id : ProposalId;
        title : Text;
        description : Text;
        change : Text;
        state : ProposalState;
        approve_votes : Nat;
        reject_votes : Nat
    };

    // pType : ProposalType

    type ProposalType = {
        #change_text; //just text
        #update_min_vp; //just nat
        #update_threshold; //just nat
        #create_lottery // amount, price per, share %, winning %
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
    var MIN_VP_REQUIRED = 1;
    var PROPOSAL_VP_THESHOLD = 100;
    //struct for neurons, hashmap? <Principal, Buffer.Buffer<Neuron>>
    //struct for user balances?  <Principal, Nat>
    //struct for user votes?  <Principal, Map<id, vote>>

    public shared (msg) func submit_proposal(title : Text, description : Text, change : Text) : async () {
        //check balance TODO
        let p : Proposal = {
            id = proposals.size();
            title = title;
            description = description;
            change = change;
            approve_votes = 0;
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

    public shared ({ caller }) func vote(id : ProposalId, choice : VotingOptions) : async () {

        Debug.print("HELLO");
        Debug.print(debug_show (id));
        Debug.print(debug_show (choice));
        //check if already voted? TODO

        //check balance TODO
        let user_vp = verify_balance(caller);
        if (user_vp <= MIN_VP_REQUIRED) return;

        let p : Proposal = proposals.get(id);
        //if approved or rejectedcan't vote' TODO
        if (p.state == #approved or p.state == #rejected) return;

        var state = p.state;
        var approve_votes = p.approve_votes;
        var reject_votes = p.reject_votes;
        switch choice {
            case (#approve) {
                Debug.print("im here");
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

        proposals.put(p.id, updated_p);
        Debug.print(debug_show (proposals.get(p.id)));
        if (state == #approved) execute_change(p.change);

    };

    private func verify_balance(user : Principal) : Nat {
        return 10; //TEMP
    };

    private func execute_change(change : Text) : () {
        //TODO
        //Webpage.update_body(change)
    }

    //advanced

    // modify_parameters
    // quadratic_voting
    // createNeuron
    // dissolveNeuron

}
