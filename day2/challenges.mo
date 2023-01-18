import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Char "mo:base/Char";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Array "mo:base/Array";

actor {

    public query func average_array(array : [Int]) : async Int {
        var avg : Int = 0;
        for (i in array.vals()) {
            avg := avg + i;
        };
        avg := avg / array.size();
        return avg;
    };

    public query func count_character(t : Text, c : Char) : async Nat {
        var count : Nat = 0;

        for (i in t.chars()) {
            if (i == c) count := count + 1;
        };
        return count;
    };

    public query func factorial(n : Nat) : async Nat {
        if (n == 0 or n == 1) return 1;

        var i = n;
        var fact = n;
        label fl loop {
            if (i == 2) break fl;

            fact := fact * (i - 1);
            i := i -1;
        };
        return fact;
    };

    // alternative method
    // public query func number_of_words(t : Text) : async Nat {
    //     var word_count = 0;
    //     var check : Bool = false;
    //     label wc for (i in t.chars()) {
    //         if (check and Char.isWhitespace(i)) check := false;

    //         if (not Char.isWhitespace(i) and not check) {
    //             check := true;
    //             word_count := word_count +1;
    //         };
    //     };
    //     return word_count;
    // };

    type Pattern = { #char : Char; #text : Text; #predicate : (Char -> Bool) };

    public query func number_of_words(t : Text) : async Nat {
        var word_count = 0;
        let ws : Pattern = #char(' ');
        let arr = Iter.toArray(Text.split(t, ws));
        Array.filter<Text>(
            arr,
            func(e : Text) {
                if (Text.size(e) != 0) {
                    return true;
                };
                return false;
            },
        ).size();
    };

    public query func convert_to_binary(n : Nat) : async Text {
        var binary_number = "";
        if (n == 0) return "0";
        var num = n;
        while (num > 0) {
            if (num % 2 == 0) binary_number := "0" # binary_number else binary_number := "1" # binary_number;
            num := num / 2;
        };
        return binary_number;
    };

    public query func find_duplicates(a : [Nat]) : async [Nat] {
        let buffer = Buffer.Buffer<Nat>(a.size());
        for (i in a.vals()) {
            var count = 0;
            label dups for (j in a.vals()) {
                if (i == j) count := count +1;
                if (count == 2 and not Buffer.contains<Nat>(buffer, i, Nat.equal)) {
                    buffer.add(i);
                    break dups;
                };

            };
        };

        let array = Buffer.toArray(buffer);
        return array;
    };

};
