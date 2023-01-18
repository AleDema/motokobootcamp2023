import Array "mo:base/Array";

module Utils {
    public func second_maximum(array : [Int]) : Int {
        if (array.size() < 2) return array[0];

        var first : Int = array[0];
        var second : Int = array[0];
        for (n in array.vals()) {
            if (n > first) {
                second := first;
                first := n;
            } else if (n > second and n != first) {
                second := n;
            } else if (first == second and n < second) {
                second := n;
            };
        };

        return second;

    };

    public func remove_even(array : [Nat]) : [Nat] {
        Array.filter<Nat>(array, func x = x % 2 == 1);
    };

    public func drop<T>(xs : [T], n : Nat) : [T] {
        var count = 0;
        Array.filter<T>(
            xs,
            func(e) {
                if (count < n) {
                    count := count +1;
                    return false;
                };
                return true;
            },
        );
    };
};
