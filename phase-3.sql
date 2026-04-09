DROP SCHEMA IF EXISTS SIGHTINGS CASCADE;
CREATE SCHEMA IF NOT EXISTS SIGHTINGS;

SET SEARCH_PATH TO SIGHTINGS, PUBLIC;

CREATE TABLE SOURCE (
    Source_ID SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    URL VARCHAR(255) 
        CHECK (URL ~* '^(https?://)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(/.*)?$'),
    Issue VARCHAR(25)
);

CREATE TABLE REPORT (
    Report_ID SERIAL PRIMARY KEY,
    Report_Type VARCHAR(50) NOT NULL,
    Headline VARCHAR(255),
    Submitted_Date DATE NOT NULL,
    Author VARCHAR(50) NOT NULL,
    Source_ID INT NOT NULL,
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
    Environment_Details TEXT,
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
    Event_Type VARCHAR(50) NOT NULL,
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