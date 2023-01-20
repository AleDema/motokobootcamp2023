import L "mo:base/List";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import HashMap "mo:base/HashMap";
import Int8 "mo:base/Int8";
import Iter "mo:base/Iter";

actor {

    func unique<T>(l : L.List<T>, equal : (T, T) -> Bool) : L.List<T> {
        let buffer = Buffer.Buffer<T>(L.size<T>(l));
        L.filter<T>(
            l,
            func(e) {

                if (not Buffer.contains<T>(buffer, e, equal)) {
                    buffer.add(e);
                    return true;
                } else {
                    return false;
                };

            },
        );
    };

    func reverse<T>(l : L.List<T>) : L.List<T> {
        L.reverse<T>(l);
    };

    public shared ({ caller }) func is_anynomous() : async Bool {
        Principal.equal(caller, Principal.fromText("2vxsx-fae"));
    };

    func find_in_buffer<T>(buf : Buffer.Buffer<T>, val : T, equal : (T, T) -> Bool) : async Nat {
        Option.get(Buffer.indexOf<T>(val, buf, equal), buf.size() +1);
    };

    let usernames = HashMap.HashMap<Principal, Text>(0, Principal.equal, Principal.hash);

    public shared ({ caller }) func add_username(name : Text) : async () {
        usernames.put(caller, name);
    };

    public query func get_usernames() : async [(Principal, Text)] {
        return (Iter.toArray(usernames.entries()));
    };
};
