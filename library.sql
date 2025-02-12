create database Library;

use Library;

-- Create the 'tbl_publisher' table
CREATE TABLE publisher (
    publisher_PublisherName VARCHAR(100) PRIMARY KEY,
    publisher_PublisherAddress VARCHAR(255),
    publisher_PublisherPhone VARCHAR(15)
);

-- Create the 'tbl_book' table
CREATE TABLE books (
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(100),
    FOREIGN KEY (book_PublisherName) REFERENCES publisher(publisher_PublisherName)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the 'tbl_book_authors' table
CREATE TABLE authors (
    book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(100),
    FOREIGN KEY (book_authors_BookID) REFERENCES books(book_BookID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the 'tbl_library_branch' table
CREATE TABLE library_branch (
    library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress VARCHAR(255)
);

-- Create the 'tbl_book_copies' table
CREATE TABLE book_copies (
    book_copies_CopiesID INT AUTO_INCREMENT PRIMARY KEY,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES books(book_BookID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_copies_BranchID) REFERENCES library_branch(library_branch_BranchID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the 'tbl_borrower' table
CREATE TABLE borrower (
    borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(100),
    borrower_BorrowerAddress VARCHAR(255),
    borrower_BorrowerPhone VARCHAR(15)
);

-- Create the 'tbl_book_loans' table
CREATE TABLE book_loans (
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut varchar(50),
    book_loans_DueDate varchar(50),
    FOREIGN KEY (book_loans_BookID) REFERENCES books(book_BookID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES library_branch(library_branch_BranchID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES borrower(borrower_CardNo)
    ON DELETE CASCADE ON UPDATE CASCADE
);


select * from publisher;

select * from books;

select * from authors;

select * from library_branch;

select * from book_copies;

select * from borrower;

select * from book_loans;

-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT bc.book_copies_No_Of_Copies
FROM book_copies bc
JOIN books b ON bc.book_copies_BookID = b.book_BookID
JOIN library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
AND lb.library_branch_BranchName = 'Sharpstown';


-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT bc.book_copies_No_Of_Copies,lb.library_branch_BranchName
FROM book_copies bc
JOIN books b ON bc.book_copies_BookID = b.book_BookID
JOIN library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe';

-- 3.Retrieve the names of all borrowers who do not have any books checked out
SELECT b.borrower_BorrowerName
FROM borrower b
LEFT JOIN book_loans bl ON b.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_CardNo IS NULL;

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose
-- DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 

with cte as (select bl.book_loans_BookID, bl.book_loans_CardNo from book_loans bl
join library_branch lb
ON bl.book_loans_BranchID = lb.library_branch_BranchID 
where library_branch_BranchName = "Sharpstown" and book_loans_DueDate = "2/3/18")
select b.book_Title, br.borrower_BorrowerName, br.borrower_BorrowerAddress
FROM cte  
join books b on cte.book_loans_BookID = b.book_BookID
JOIN borrower br ON cte.book_loans_CardNo = br.borrower_CardNo;

-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.library_branch_BranchName, COUNT(bl.book_loans_LoansID) as TotalBooksLoaned from book_loans bl
join library_branch lb
on bl.book_loans_BranchID = lb.library_branch_BranchID
group by lb.library_branch_BranchName;

-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select br.borrower_BorrowerName, br.borrower_BorrowerAddress, COUNT(bl.book_loans_LoansID) as NumBooksCheckedOut from borrower br
join book_loans bl
ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_BorrowerName, br.borrower_BorrowerAddress
HAVING COUNT(bl.book_loans_LoansID) > 5;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

SELECT b.book_Title, bc.book_copies_No_Of_Copies
FROM books b
JOIN book_copies bc ON b.book_BookID = bc.book_copies_BookID
WHERE b.book_BookID IN (
    SELECT book_authors_BookID
    FROM authors
    WHERE book_authors_AuthorName = 'Stephen King'
)
AND bc.book_copies_BranchID = (
    SELECT library_branch_BranchID
    FROM library_branch
    WHERE library_branch_BranchName = "Central"
);


