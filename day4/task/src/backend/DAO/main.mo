import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Trie "mo:base/Trie";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
//import Webpage "canister:Webpage";
import G "./GovernanceTypes";
// import Map "mo:hashmap/Map";
import Map "../utils/Map";

actor {

    type VotingPowerLogic = {
        #basic;
        #advanced
    };

    type NeuronState = {
        #locked;
        #dissolving;
        #dissolved
    };

    type Neuron = {
        id : Nat;
        stake : Nat;
        creation_date : Nat;
        dissolve_delay : Nat;
        state : NeuronState
    };

    type ProposalId = G.ProposalId;
    type Proposal = G.Proposal;
    type ProposalType = G.ProposalType;
    type ProposalState = G.ProposalState;
    type VotingOptions = G.VotingOptions;
    type Vote = G.Vote;

    var DEV_MODE = true;

    stable var MIN_VP_REQUIRED = 1;
    stable var PROPOSAL_VP_THESHOLD = 100;
    stable var IS_QUADRATIC = false;
    private var current_vp_mode : VotingPowerLogic = #basic;

    private stable var proposal_id_counter = 0;
    let { ihash; nhash; thash; phash; calcHash } = Map;
    private stable let proposals = Map.new<Nat, Proposal>();
    private stable let user_votes = Map.new<Principal, Map.Map<ProposalId, Vote>>();
    private stable let neurons = Map.new<Principal, [Neuron]>();
    private stable let user_balances = Map.new<Principal, Nat>();

    public shared (msg) func submit_proposal(title : Text, description : Text, change : ProposalType) : async () {
        if (verify_balance(msg.caller) < MIN_VP_REQUIRED) return;

        let p : Proposal = {
            id = proposal_id_counter;
            title = title;
            description = description;
            change_data = change;
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

        //check balance
        let user_vp = verify_balance(caller);
        if (user_vp <= MIN_VP_REQUIRED) return;

        let p : Proposal = do {
            switch (Map.get(proposals, nhash, id)) {
                case (?proposal) proposal;
                case (_) return //does it return null or return the func?
            }
        };

        //check if already voted
        var hasVoted = false;

        let test1 : ?Map.Map<ProposalId, Vote> = do ? {
            let first = Map.get(user_votes, phash, caller);
            first!
        };

        let test2 : ?Vote = do ? {
            let first = Map.get(user_votes, phash, caller);
            let second = Map.get(first!, nhash, id);
            second!
        };

        switch (test1, test2) {
            case (?exists1, ?exist2) {
                hasVoted := true
            };
            case (?exist1, _) {
                var init_votes : Map.Map<ProposalId, Vote> = Map.new<ProposalId, Vote>();
                ignore Map.put(exist1, nhash, id, { voting_power = user_vp; vote = choice })
            };
            case (_, _) {
                //both false
                var init_votes : Map.Map<ProposalId, Vote> = Map.new<ProposalId, Vote>();
                ignore Map.put(init_votes, nhash, id, { voting_power = user_vp; vote = choice });
                ignore Map.put(user_votes, phash, caller, init_votes)
            }
        };

        if (hasVoted) return;

        //if approved or rejected can't vote'
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
        //Debug.print(debug_show (Map.get(proposals, nhash, id)));
        if (state == #approved) await execute_change(p.change_data);

    };

    //TODO actually implement this
    private func verify_balance(user : Principal) : Nat {
        if (DEV_MODE) {
            return 10
        } else return 10; //TODO

    };

    private func get_voting_power(user : Principal) : Nat {
        switch (current_vp_mode) {
            case (#basic) verify_balance(user);
            case (#advanced) get_neurons_vp(user)
        }
    };

    private func get_neurons_vp(user : Principal) : Nat {
        var vp = 0;
        if (DEV_MODE) {
            vp := 10
        } else vp := 10; //TODO

        if (IS_QUADRATIC) {
            // damn numerical conversions
            // var ftval = Float.fromInt(vp);
            // var sqr = Float.sqrt(ftval);
            // let i64_vp = Float.toInt64(sqr)
        };

        return vp
    };

    private func execute_change(change : ProposalType) : async () {
        //TODO proposal types
        //ignore Webpage.update_body(change)
        switch (change) {
            case (#change_text(new_text)) {
                //ignore Webpage.update_body(change)
            };
            case (#update_min_vp(new_vp)) {
                MIN_VP_REQUIRED := new_vp
            };
            case (#update_threshold(new_th)) {
                PROPOSAL_VP_THESHOLD := new_th
            };
            case (#toggle_quadratic) {
                IS_QUADRATIC := not IS_QUADRATIC
            };
            case (#create_lottery(amount, price, share_percentage, winning_percentage)) {
                //todo
            }
        }
    };

    public shared ({ caller }) func create_neuron(stake : Nat, dissolve_delay : Nat) : async () {

    };

    public shared ({ caller }) func dissolve_neuron(id : Nat) : async () {

    };

    //advanced

    // modify_parameters
    // quadratic_voting
    // createNeuron
    // dissolveNeuron
    //toptup

}
