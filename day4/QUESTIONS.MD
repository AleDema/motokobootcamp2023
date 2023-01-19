1) Is the heap memory saved when upgrading a canister? How much heap memory does a canister has?
- Heap memory is not saved across upgrades and it currently has 4GB.

2) How much accounts can a unique Principal own?
- 4,294,967,295

3) Can we safely upgrade a canister from interface A to interface B?
Interface A

```
actor {
  public func greet(surname : Text, firstname : Text) : async Text {
    return "Hello" # firstname # surname # " !";
  };
}
```motoko
Interface B
```motoko
actor {
  public func greet(firstname : Text) : async Text {
    return "Hello" # firstname # " !";
  };
}
```
syntactically the upgrade is possible, but semantically it might not be, cause legacy 3rd party canisters will pass surname in place of firstname;