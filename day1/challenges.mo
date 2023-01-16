import Nat "mo:base/Nat";

actor {
    public query func multiply(n : Nat, m : Nat) : async Nat {
        m * n;
    };

    public query func volume(n : Nat) : async Nat {
        Nat.pow(n, 3);
    };

    public query func hours_to_minutes(n : Nat) : async Nat {
        n * 60;
    };

    var counter : Nat = 0;
    public query func get_counter() : async Nat {
        counter;
    };

    public func set_counter(n : Nat) : async () {
        counter := n;
    };

    public query func test_divide(n : Nat, m : Nat) : async Bool {
        test_divide_internal(n, m);
    };

    private func test_divide_internal(n : Nat, m : Nat) : Bool {
        n % m == 0;
    };

    public query func is_even(n : Nat) : async Bool {
        test_divide_internal(n, 2);
    };

};
