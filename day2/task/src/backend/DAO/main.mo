import Principal "mo:base/Principal";
actor {

    var currentValue : Nat = 0;

    public func increment() : async () {
        currentValue += 1
    };

    public query func getValue() : async Nat {
        currentValue
    };

    public shared query (msg) func whoami() : async Principal {
        return msg.caller
    }
}
