# Databases

This project simulates a relational database for a music festival organizer. The challenge is split into two main parts and focuses on:

- SQL DML and DQL
- Table creation and data loading
- Writing complex queries
- Implementing PL/SQL: procedures, functions, triggers, and events
- Data integrity and automation

🔁 Part I:
✅ Goals
Create and populate isolated exchange rate tables: fx_from_usd, fx_to_usd
Use LOAD DATA LOCAL INFILE to import data from CSVs
Write a set of SQL queries to answer real-world festival-related questions
🗂 Files
- Creates the fx_from_usd and fx_to_usd tables and loads conversion data from CSV files.
challenge2-queries.sql:
Implements 20+ queries as SQL views, such as:
- Dishes for specific artist preferences
- Security guard capabilities
- Ticket vendors by artist
- Festival ticket sales evolution
- Underage drinking detection
- Band collaborations
- Staff role audits
- Festivalgoer spending

🔁 Part II — Procedures, Functions & Events

✅ Goals
Build modular, reusable database logic
Work with:
FUNCTIONs for rounding, currency validation
PROCEDUREs for currency conversion, auto-filling data, correcting underage sales
TRIGGERs to automatically populate a payments table
EVENTs to schedule daily data updates
🗂 Files
✅ req01: Round a float to 2 decimals
✅ req02: Validate currency code against loaded conversion tables
✅ req04: Convert currency to/from USD with error handling
✅ req05: Populate future missing conversion rates using random historical values
✅ req06: Schedule daily population using MySQL EVENTS
✅ req07: Determine default currency by nationality
✅ req08: Auto-create payment records when beers or drinks are sold
✅ req10: Detect and "fix" underage alcohol sales by reassigning them


