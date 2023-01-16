1) How much is the current memory capacity of a canister? 
- 48GB stable memory, 4GB heap

2) What is the issue with the following code sample?
actor {
  let counter : Nat = 0;
  public func increment_counter() : async () {
    counter := counter + 1;
  };
}
- counter is an immutable value

3) What is the issue with the following code sample?
actor {
  var message : Text = 0;

  public query func change_message(new_message : Text) : async () {
    message := new_message;
    return;
  };
  
  public query func see_message() : async Text {
    return(message);
  };
}

- change_message is a query type function so the state changes are discarded after it ends and message isn't actually modified


4) False or True: we can remove the keyword async for return argument of a query function since queries are faster to answer.
False