module Book {
    public type Book = {
        title : Text;
        pages : Nat;
    };

    public func create_book(title : Text, pages : Nat) : Book {
        //read??
        return { title = title; pages = pages };
    };
};
