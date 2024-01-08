create database library;
use library;
CREATE TABLE tbl_publisher (
    publisher_publisherName VARCHAR(255) PRIMARY KEY NOT NULL,
    publisher_publisherAddress VARCHAR(255) NOT NULL,
    publisher_publisherPhone varchar(255)
);


select * from tbl_publisher;

CREATE TABLE tbl_borrower (
    borrower_cardNo bigINT PRIMARY KEY AUTO_INCREMENT,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress VARCHAR(255),
    borrower_BorrowerPhone varchar(255)
) AUTO_INCREMENT = 100;

select * from tbl_borrower;

create table  tbl_library_branch(
    library_branch_BranchID bigint primary key auto_increment,
    library_branch_BranchName varchar(255),
    library_branch_BranchAddress varchar(255)
    );
    
    select * from tbl_library_branch;
    
CREATE TABLE tbl_book (
    book_BookID tinyint PRIMARY KEY AUTO_INCREMENT,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher (publisher_publisherName) ON DELETE CASCADE
);


select * from  tbl_book;

CREATE TABLE tbl_book_authors (
    book_authors_AuthorID tinyINT PRIMARY KEY AUTO_INCREMENT,
    book_authors_bookID tinyINT , FOREIGN KEY (book_authors_bookID) REFERENCES tbl_book (book_BookID) ON DELETE CASCADE,
    book_authors_AuthorName VARCHAR(255)
    
);

select * from tbl_book_authors;

create table tbl_book_copies(
book_copies_copiesID tinyint primary key auto_increment,
book_copies_BookID tinyint, foreign key (book_copies_BookID) references tbl_book (book_BookID) on delete cascade,
book_copies_BranchID bigint, foreign key (book_copies_BranchID) references tbl_library_branch (library_branch_branchID) on delete cascade,
book_copies_No_of_Copies int
);

select * from tbl_book_copies;

create table tbl_book_loans(
book_loans_LoansID tinyint primary key auto_increment,
book_loans_BookID tinyint, foreign key (book_loans_BookID) references  tbl_book (book_BookID) on delete cascade,
book_loans_BranchID bigint, foreign key (book_loans_BranchID) references tbl_library_branch (library_branch_branchID) on delete cascade,
book_loans_CardNo  bigint, foreign key (book_loans_CardNo) references tbl_borrower (borrower_CardNo) on delete cascade,
book_loans_DateOut varchar(255),
book_loans_DueDate varchar(255)
);

select * from tbl_book_loans;
--    TASK QUESTIONS
-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select book_Copies_No_of_Copies, book_title, library_branch_BranchName
from tbl_book
join tbl_book_copies
on book_copies_bookID = book_BookID
join tbl_library_branch
on book_copies_BranchID = library_branch_BranchID
where book_title = 'the lost tribe' and  library_branch_BranchName = 'sharpstown';

-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select book_Copies_No_of_Copies, book_title, library_branch_BranchName
from tbl_book
join tbl_book_copies
on book_copies_bookID = book_BookID
join tbl_library_branch
on book_copies_BranchID = library_branch_BranchID
where book_title = 'the lost tribe';

-- Retrieve the names of all borrowers who do not have any books checked out.
select borrower_BorrowerName
from tbl_borrower
left join tbl_book_loans
on borrower_CardNo = book_loans_CardNo
where book_loans_CardNo is null;

-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.
 SELECT
    tbl_borrower.borrower_BorrowerName,
    tbl_borrower.borrower_BorrowerAddress,
    tbl_book.book_title
FROM
    tbl_borrower
join tbl_book_loans ON tbl_borrower.borrower_CardNo = tbl_book_loans.book_loans_CardNo
 JOIN tbl_library_branch ON tbl_book_loans.book_loans_branchID = tbl_library_branch.library_branch_BranchID
JOIN tbl_book ON tbl_book_loans.book_loans_BookID = tbl_book.book_BookID
WHERE
    tbl_book_loans.book_loans_DueDate = '2018-03-02' and library_branch_BranchName = 'sharpstown';
    

-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select library_branch_BranchName, count(book_loans_BookID)
from tbl_library_branch
join tbl_book_loans
on book_loans_BranchID = library_branch_BranchID
group by library_branch_BranchName ;

-- Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT
    borrower_BorrowerName,
    borrower_BorrowerAddress,
    COUNT(book_loans_BookID) AS loan_count
FROM
    tbl_borrower
JOIN tbl_book_loans ON tbl_borrower.borrower_CardNo = tbl_book_loans.book_loans_CardNo
GROUP BY
    borrower_BorrowerName,
    borrower_BorrowerAddress
HAVING
    loan_count > 5;


-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select book_authors_AuthorName,book_copies_No_Of_Copies,library_branch_branchName,book_Title
from tbl_book_authors
join tbl_book
on book_authors_BookID = book_BookID
join tbl_book_copies
on book_BookID = book_copies_BookID
join tbl_library_branch
on book_copies_BranchID = library_branch_BranchID
where book_authors_AuthorName = 'Stephen King' and library_branch_branchName = 'Central' ;









    

    