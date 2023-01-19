import L "mo:base/List";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import HashMap "mo:base/HashMap";
import Int8 "mo:base/Int8";
import Iter "mo:base/Iter";

actor {
    type List<T> = L.List<T>;

    // func unique<T>(l : List<T>, equal : (T, T) -> Bool) : List<T> {
    //     let dups = HashMap.HashMap<T, Int8>(0, equal, T.hash);
    //     List<T>.filter<T>(
    //         l,
    //         func(e) {
    //             if (not dups.get(e)) {
    //                 dups.put(e);
    //                 return true;
    //             };
    //             return false;
    //         },
    //     );
    // };

    func reverse<T>(l : List<T>) : List<T> {
        L.reverse<T>(l);
    };

    public shared ({ caller }) func is_anynomous() : async Bool {
        Principal.equal(caller, Principal.fromText("2vxsx-fae"));
    };

    func find_in_buffer<T>(buf : Buffer.Buffer<T>, val : T, equal : (T, T) -> Bool) : async Nat {
        Option.get(Buffer.indexOf<T>(val, buf, equal), buf.size() +1) //not sure;
    };

    let usernames = HashMap.HashMap<Principal, Text>(0, Principal.equal, Principal.hash);

    public shared ({ caller }) func add_username(name : Text) : async () {
        usernames.put(caller, name);
    };

    public query func get_usernames() : async [(Principal, Text)] {
        return (Iter.toArray(usernames.entries()));
    };
};
