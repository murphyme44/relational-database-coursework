# University Course Management System – SQL Schema Coursework

This repository contains a multi-part Oracle SQL database design project developed as part of a university course. The goal was to design, normalize, and extend a course management system through progressive assignments using SQL DDL, sequences, and triggers.

## 🧠 Overview

The database models a university course registration system with entities such as Students, Courses, Sections, Instructors, Grades, and more. It includes:

- Primary and foreign key constraints
- Triggers for audit tracking and ID generation
- Sequences for auto-incrementing primary keys
- Multi-table relationships with referential integrity

## 📁 Files

- `PS1_Solution.sql` – Base schema creation with `COURSE`, `SECTION`, `STUDENT`, and `ENROLLMENT` tables.
- `FALL2023PDB.murphyme.PS2.sql` – Adds `SEQUENCE`s and `TRIGGER`s for automated primary key assignment.
- `FALL2023PDB.murphyme~3.sql` – Defines additional tables (`REGION`, `COUNTRY`, `LOCATION`, etc.) for broader schema integration.
- `PS4_delta.sql` – Finalizes schema with new entities like `INSTRUCTOR`, `GRADE`, and `GRADE_TYPE`. Adds audit tracking triggers and updates to existing tables.

## 📌 Assignment Breakdown

### PS1: Initial Schema
- Created foundational tables with exact data types and constraints based on a provided ER diagram.

### PS2: Triggers and Sequences
- Added `BEFORE INSERT` triggers using `NEXTVAL` sequences for `COURSE`, `SECTION`, and `STUDENT` primary keys.

### PS3: Schema Normalization & Audit Triggers
- Introduced `SCHOOL` table and refactored existing tables to include `SCHOOL_ID` in composite primary keys.
- Implemented audit triggers for `CREATED_BY`, `CREATED_DATE`, `MODIFIED_BY`, and `MODIFIED_DATE`.

### PS4: Final Expansion
- Added new tables such as `INSTRUCTOR`, `GRADE`, `GRADE_TYPE`.
- Ensured referential integrity and incorporated additional sequences and triggers.

## 🛠️ Tech Stack

- **Database**: Oracle 19c (via AWS)
- **Tools**: Oracle SQL Developer
- **Languages**: Oracle SQL, PL/SQL

## 📎 How to Use

1. Open Oracle SQL Developer.
2. Connect to the AWS-hosted Oracle instance with provided credentials.
3. Run the scripts in order (`PS1` → `PS2` → `PS3` → `PS4_delta`) to build the schema progressively.
- ⚠️ Note: The Lab3FullSQL.sql script used during PS4 is instructor-provided and not included in this repository. It resets the schema to the state at the end of PS3 before applying the delta script.
