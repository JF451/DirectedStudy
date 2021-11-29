

create table Users(
	UserID INTEGER PRIMARY KEY AUTOINCREMENT,
	Passwd VARCHAR(50) NOT NULL,
	Username VARCHAR(50) NOT NULL
);

create table Rating (
	RatingID INTEGER PRIMARY KEY AUTOINCREMENT,
	Picture VARCHAR(50),
	Rating INTEGER,
	UserID_fk INTEGER,
	foreign key(UserID_fk) references Users(UserID) 
);

create table Interests(
	InterestID INTEGER PRIMARY KEY AUTOINCREMENT,
	interest VARCHAR(50),
	UserID_fk INTEGER,
	foreign key(UserID_fk) references Users(UserID)
);
