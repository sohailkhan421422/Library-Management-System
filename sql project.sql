-- DATABASE CREATION
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;
-- TABLE CREATION

-- TABLE: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);


-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);

-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);

-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);

-- TASK 1:How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
SELECT lb.library_branch_BranchName,SUM(bc.book_copies_No_Of_Copies) AS total_copies
FROM tbl_book b
JOIN tbl_book_copies bc 
ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb 
ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE TRIM(LOWER(b.book_Title)) = 'the lost tribe'
AND TRIM(LOWER(lb.library_branch_BranchName)) = 'sharpstown'
GROUP BY lb.library_branch_BranchName;

-- TASK 2:How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT lb.library_branch_BranchName, bc.book_copies_No_Of_Copies
FROM tbl_book b, tbl_book_copies bc, tbl_library_branch lb
WHERE b.book_BookID = bc.book_copies_BookID
AND bc.book_copies_BranchID = lb.library_branch_BranchID
AND b.book_Title = 'The Lost Tribe';

-- TASK 3:Retrieve the names of all borrowers who do not have any books checked out.
SELECT borrower_BorrowerName
FROM tbl_borrower
WHERE borrower_CardNo NOT IN (
SELECT book_loans_CardNo FROM tbl_book_loans
);

-- Task4:For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
SELECT b.book_Title,br.borrower_BorrowerName,br.borrower_BorrowerAddress
FROM tbl_book_loans bl
JOIN tbl_book b ON bl.book_loans_BookID = b.book_BookID
JOIN tbl_borrower br ON bl.book_loans_CardNo = br.borrower_CardNo
JOIN tbl_library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE lb.library_branch_BranchName = 'Sharpstown'
AND bl.book_loans_DueDate = '2018-02-03';


-- TASK 5:For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT library_branch_BranchName, COUNT(book_loans_LoansID) AS TotalBooks
FROM tbl_library_branch lb, tbl_book_loans bl
WHERE lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY library_branch_BranchName;




-- TASK 6:Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT br.borrower_BorrowerName, br.borrower_BorrowerAddress,
COUNT(bl.book_loans_LoansID) AS BooksCount
FROM tbl_borrower br, tbl_book_loans bl
WHERE br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_CardNo
HAVING COUNT(bl.book_loans_LoansID) > 5;



-- TASK 7:For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT b.book_Title, bc.book_copies_No_Of_Copies
FROM tbl_book b, tbl_book_authors ba, tbl_book_copies bc, tbl_library_branch lb
WHERE b.book_BookID = ba.book_authors_BookID
AND b.book_BookID = bc.book_copies_BookID
AND bc.book_copies_BranchID = lb.library_branch_BranchID
AND ba.book_authors_AuthorName = 'Stephen King'
AND lb.library_branch_BranchName = 'Central';


select* from  tbl_library_branch;