CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_latter_sent BOOLEAN,
    cover_latter_file_name VARCHAR(255),
    status VARCHAR(50)
);

INSERT INTO job_applied
    (
        job_id,
        application_sent_date,
        custom_resume,
        resume_file_name,
        cover_latter_sent,
        cover_latter_file_name,
        status)
VALUES  (1,
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'
), (2,
    '2024-02-02',
    false,
    'resume_02.pdf',
    false,
    NULL,
    'interview scheduled'
),(3,
    '2024-02-03',
    false,
    'resume_03.pdf',
    false,
    'cover_letter_03.pdf',
    'ghosted'
),(4,
    '2024-02-04',
    false,
    'resume_04.pdf',
    false,
    'cover_letter_04.pdf',
    'submitted'
),(5,
    '2024-02-05',
    false,
    'resume_05.pdf',
    false,
    'cover_letter_05.pdf',
    'rejected'
);

upadte table column or table
ALTER TABLE job_applied
ADD contact VARCHAR(50);


-- update the values of the existing data
UPDATE job_applied
SET contact = 'Elrich Bachman'
Where job_id = 1;

UPDATE job_applied
SET contact = 'Denesh Chugtai'
Where job_id = 2;

UPDATE job_applied
SET contact = 'Bertram Gilfoyle'
Where job_id = 3;

UPDATE job_applied
SET contact = 'Jian Yang'
Where job_id = 4;

UPDATE job_applied
SET contact = 'Big Head'
Where job_id = 5;


-- alter table name or fields
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name

-- Change contact data type
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

-- Remove column from table
ALTER TABLE job_applied
DROP COLUMN contact_name;


-- Delete existing table
DROP TABLE job_applied


SELECT *
FROM job_applied;