import Utils "./utils";
import Book "./book";
import List "mo:base/List";
actor {

    var book_list = List.nil<Book.Book>();
    public func add_book(book : Book.Book) : async () {
        ignore List.push<Book.Book>(book, book_list);
    };

    public query func get_books() : async [Book.Book] {
        List.toArray(book_list);
    };
};
