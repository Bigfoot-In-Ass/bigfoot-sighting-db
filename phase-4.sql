DROP SCHEMA IF EXISTS SIGHTINGS CASCADE;
CREATE SCHEMA IF NOT EXISTS SIGHTINGS;

SET SEARCH_PATH TO SIGHTINGS, PUBLIC;

CREATE TABLE SOURCE (
    Source_ID SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    URL VARCHAR(255) 
        CHECK (URL ~* '^(https?://)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(/.*)?$'),
    Issue TEXT
);

CREATE TABLE REPORT (
    Report_ID SERIAL PRIMARY KEY,
    Report_Type VARCHAR(50) NOT NULL,
    Headline VARCHAR(255),
    Submitted_Date DATE NOT NULL,
    Author VARCHAR(50) NOT NULL,
    Source_ID INT,
    FOREIGN KEY (Source_ID) REFERENCES SOURCE(Source_ID) ON DELETE CASCADE
);

CREATE TABLE INVESTIGATOR (
    Investigator_ID SERIAL PRIMARY KEY,
    Investigator_Name VARCHAR(50) NOT NULL,
    Title VARCHAR(50),
    Organization VARCHAR(100)
);

CREATE TABLE FOLLOW_UP (
    Report_ID INT NOT NULL,
    Investigator_ID INT NOT NULL,
    Follow_Up_Date DATE NOT NULL,
    Notes TEXT,
    PRIMARY KEY (Report_ID, Investigator_ID, Follow_Up_Date),
    FOREIGN KEY (Report_ID) REFERENCES REPORT(Report_ID) ON DELETE CASCADE,
    FOREIGN KEY (Investigator_ID) REFERENCES INVESTIGATOR(Investigator_ID) ON DELETE CASCADE
);

CREATE TABLE ENVIRONMENT (
    Environment_ID SERIAL PRIMARY KEY,
    -- may need to process this into a concatenated string
    Environment_Description TEXT,
    -- Environment_Details TEXT,
    Season VARCHAR(20),
    -- May need to group date and time information into a single column
    -- Date DATE,
    -- process each date using the information in the report
    Year INT CHECK (Year <= EXTRACT(YEAR FROM CURRENT_DATE)),
    Month INT CHECK (Month >= 1 AND Month <= 12),
    Date_Text VARCHAR(20),
    Time_And_Conditions VARCHAR(100)
);

CREATE TABLE LOCATION (
    Location_ID SERIAL PRIMARY KEY,
    State VARCHAR(50),
    County VARCHAR(50),
    Nearest_Town VARCHAR(50),
    Nearest_Road VARCHAR(50),
    Location_Details TEXT,
    A_G_Reference VARCHAR(50)
);

CREATE TABLE EVENT (
    Event_ID SERIAL PRIMARY KEY,
    Event_Type VARCHAR(50) NOT NULL 
        CHECK (Event_Type IN ('Class A', 'Class B', 'Class C')),
    -- may need to process this into a concatenated string
    Observerd_Description TEXT,
    Other_Witnesses TEXT,
    Witness_other_stories TEXT,
    Also_Noticed TEXT,
    Report_ID INT NOT NULL,
    Environment_ID INT,
    Location_ID INT,
    FOREIGN KEY (Report_ID) REFERENCES REPORT(Report_ID) ON DELETE CASCADE,
    FOREIGN KEY (Environment_ID) REFERENCES ENVIRONMENT(Environment_ID) ON DELETE SET NULL,
    FOREIGN KEY (Location_ID) REFERENCES LOCATION(Location_ID) ON DELETE SET NULL
);


-- Source Inserts Generated from data-processing-pipeline.ipynb
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (1, 'The Delta Discovery', 'http://www.deltadiscovery.com/story/2013/01/23/in-our-native-land/legendary-bigfoot-sighted-near-kasigluk/817.html', 'Volume 15, Issue 4');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (2, 'he Clanton Advertiser', 'http://www.clantonadvertiser.com/articles/2004/07/10/opinion/for_the_record/5-editorial.txt', 'Researches from around the country have contacted The Advertiser with their take on the situation. It''s made some older locals celebrities, even if only for a short period of time. It''s even drawn calls to the paper from others who claim to see the giant monkey men of Chilton County. This was one of those great stories that was just too outlandish to have made up. It''s one that when a reporter hears the initial details, his eyes began to sparkle and his mouth begins to water because he knows he''s on to something. Thanks to all those were willing to talk about the bigfoot sightings of Chilton County in 1960.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (3, 'BC13 Birmingham Tuscaloosa Alabama', 'http://www.nbc13.com/news/3508750/detail.html', 'For decades people there have been talking about the strange creature that apparently has an affinity for the local peach crop.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (4, 'The Clanton Advertiser', 'http://www.clantonadvertiser.com/articles/2004/07/07/news/a-news.txt', 'It''s been almost 25-years since the original report was filed in the fall of 1960 but that hasn''t stopped Bigfoot spotters and researchers from around the country as citing the events around Walnut Creek as a legitimate and marvelous occurrence.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (5, 'Dispatches from the LP-OP', 'http://leepeacock2010.blogspot.com/', 'According to the witnesses, who spoke to The Courant on the condition of anonymity, they were traveling west on U.S. Highway 84 on Saturday when they saw the strange creature between the Herbert and Cohassett communities in Conecuh County, Alabama.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (6, 'Texarkana Gazette', 'http://www.texarkanagazette.com/archives/index.inn?loc=detail&doc=/2001/June/24-213-news04.txt', 'Instead of unraveling mysteries a la some paperback novel hero, most days are spent pecking out bits of hard news-meetings, traffic accidents, fires.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (7, 'Texarkana Gazette', 'http://www.texarkanagazette.com/archives/index.inn?loc=detail&doc=/2001/June/24-193-feature01.txt210', 'It didn''t even make Page One of the local newspaper.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (8, 'KMPH Turn to 10', 'http://turnto10.com/news/offbeat/is-bigfoot-back-in-the-valley', 'According to paranormal expert Jeffrey Gonzalez, the most recent sighting was near Avocado Lake.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (9, 'Sports Illustrated', 'http://www.si.com/vault/1971/08/30/612120/hes-big-hes-bashful-he-smells-bad', 'At the moment no one knows from where the skunk ape came; whether it is an overgrown chimp that escaped from an old Tarzan movie set, or an orangutan that fled a bankrupt Wild West show near Fort Lauderdale, or perhaps just a little monkey greatly magnified by imagination.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (10, 'WCJB - ABC News', 'http://www.wcjb.com/local-news/2014/05/legend-skunk-ape', 'What can the dark shadow passing through the woods be?');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (11, 'Miami News', 'http://www.miaminewtimes.com/1998-02-19/news/creature-feature/full/', 'Shealy walks in front of me, a small flashlight in one hand, his tall, lean frame slightly stooped as he picks his way along an old game trail. He has spent almost all of his 34 years in Big Cypress, and he knows this part of the swamp like most people know their front yards.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (12, 'Two Egg', 'http://www.twoeggfla.com/monster.html', 'by Dale Cox');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (13, 'Ocala Star Banner', 'http://www.ocala.com/article/20140323/ARTICLES/140329871?p=1&tc=pg&tc=ar', 'By Bruce Ackerman');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (14, 'Palm Beach Post', 'http://news.google.com/newspapers?nid=1964&dat=19751119&id=GvgiAAAAIBAJ&sjid=9M0FAAAAIBAJ&pg=1430,530512', 'Although there have been no Skunk Ape sightings for several months, those who believe the monster-like creature exists are convinced it will surface again. ');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (15, 'The Ledger', 'http://www.theledger.com/article/20071028/COLUMNISTS0404/710280370/1098', '''The Skunk Ape'' of Florida');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (16, 'The Ledger', 'http://www.theledger.com/article/20041229/NEWS/412290303', 'By Gary White');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (17, 'The Ledger', 'http://search.theledger.com/apps/pbcs.dll/article?AID=/20041113/NEWS/411130309&SearchID=73286054391791', '"I''ve heard about Big Foot and stuff," Ward says. "I didn''t really think it existed, but I''m convinced now."');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (18, 'uffington Post', 'http://www.huffingtonpost.com/2013/06/14/skunk-ape-video-myakka-florida_n_3441565.html', 'But now, his poor-quality photos and video have sparked a heated debate.');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (19, 'he City Observer', 'http://www.thecityobserver.org/index.html', 'Lake Helens Bigfoot Activity');
INSERT INTO SOURCE (Source_ID, Name, URL, Issue) VALUES (20, 'The Valdosta Daily Times', 'http://www.valdostadailytimes.com/news/local_news/in-search-of-the-skunk-ape/article_7c620560-5119-5be9-8cc2-96e3649164f7.html?mode=story', '... I saw it.');

-- Report Inserts Generated from data-processing-pipeline.ipynb
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Legendary Bigfoot sighted near Kasigluk', '2013-01-23', 'By KJ Lincoln', 1);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Bigfoot sightings of years past draw some interest now', '2004-07-11', 'T', 2);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Bigfoot Legend Thrives In Chilton County: Man-Like Creature Lives In Peach Grove, According To Legend', '2004-07-08', 'N', 3);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Bigfoot sighting reaching Silver milestone', '2004-07-08', 'By Jason Cannon', 4);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Strange creature sighted near Sepulga River in Conecuh County, Alabama', '2016-07-28', 'By Lee Peacock', 5);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'The Fouke Monster 30 Years Later: Ex-journalists recall sifting fact from Fouke fiction after sighting', '2001-06-24', 'By Sunni Thibodeau', 6);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'The Fouke Monster: A look at how the media recorded the reports of the 1971 alleged sighting of a large creature in rural Miller County, Ark.', '2001-06-24', 'By Staff Writer  ', 7);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Bigfoot Sighting Reported in California', '2017-10-13', 'By Alexandra Lehnert', 8);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'He''s big! He''s bashful! He smells bad!', '1971-08-30', 'By Pat Putnam', 9);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'The Legend of the Skunk Ape', '2014-05-24', 'By Anna  Carabeo', 10);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Creature Feature', '1998-02-19', 'By Jim Kelly', 11);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'The Monster of Two Egg, Florida?', '2010-02-23', 'By Dale Cox', 12);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Woman claims Bigfoot is real, and is in the Goethe State Forest', '2014-03-23', 'By Bruce  Ackerman', 13);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Waiting for Skunk Ape to Surface Again', '1975-11-19', 'By Marilyn Alva', 14);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'The Skunk Ape of Florida', '2007-10-28', 'By Cinnamon Bair', 15);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', '"Ape" Sighting Draws Interest', '2004-12-29', 'By Gary White', 16);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', '[Our Own Loch Ness Monster?  Woman''s Sighting of Ape-Like Green Swamp Creature Among the Theories Studied by Cryptozoologists]', '2004-11-13', 'By Gary White', 17);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Skunk Ape Sighting in Myakka', '2013-06-06', 'H', 18);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'Return of the Mole Man', '2012-11-01', 'T', 19);
INSERT INTO REPORT (Report_Type, Headline, Submitted_Date, Author, Source_ID) VALUES ('Media Article', 'In Search of the Skunk Ape', '2010-05-02', 'By Dean  Poling', 20);

-- Investigator Inserts Generated from data-processing-pipeline.ipynb
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (1, 'Dr. Wolf H. Fahrenbach', 'Senior Investigator', 'Cryptozoology Society');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (2, 'Stan Courtney', 'Lead Investigator', 'Cryptid Investigation Bureau');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (3, 'Charles Lamica', 'Senior Investigator', 'Wildlife Research Institute');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (4, 'Kevin Withers', 'Chief Investigator', 'Cryptozoology Society');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (5, 'John Salmond', 'Research Investigator', 'Sighting Documentation Center');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (6, 'Conor Ameigh', 'Senior Investigator', 'BFRO');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (7, 'Joanna Cuva', 'Junior Investigator', 'BFRO');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (8, 'Mary Ross', 'Chief Investigator', 'BFRO');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (9, 'Kevin Smykal', 'Junior Investigator', 'Cryptid Investigation Bureau');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (10, 'W. Gibson', 'Junior Investigator', 'Cryptozoology Society');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (11, 'Steve Phillips', 'Research Investigator', 'Wildlife Research Institute');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (12, 'Michael  Brumfield', 'Research Investigator', 'BFRO');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (13, 'Morris Collins', 'Field Investigator', 'Wildlife Research Institute');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (14, 'Matthew Moneymaker', 'Lead Investigator', 'Wildlife Research Institute');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (15, 'Thomas Bruns', 'Chief Investigator', 'Sighting Documentation Center');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (16, 'R. Monteith', 'Junior Investigator', 'Sighting Documentation Center');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (17, 'Vince Lauria', 'Chief Investigator', 'Cryptid Investigation Bureau');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (18, 'Mick Minnis', 'Research Investigator', 'Bigfoot Field Research');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (19, 'Tal H. Branco', 'Field Investigator', 'BFRO');
INSERT INTO INVESTIGATOR (Investigator_ID, Investigator_Name, Title, Organization) VALUES (20, 'Brad Sasser', 'Lead Investigator', 'Bigfoot Field Research');
