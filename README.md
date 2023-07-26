![GitHub](https://img.shields.io/github/license/openpotato/sakila-db)

# Sakila Database

The [Sakila sample database](https://dev.mysql.com/doc/sakila/en/sakila-introduction.html) was initially developed by Mike Hillyer, a former member of the MySQL AB documentation team. It is intended to provide a standard schema that can be used for examples in books, tutorials, articles, samples, and so forth. The Sakila sample database also serves to highlight features of MySQL such as Views, Stored Procedures, and Triggers.

This repository stores the original MySQL database and ports to the following SQL databases:

+ [Firebird 4+](https://www.postgresql.org/)
+ [PostgreSQL 14+](https://firebirdsql.org/)

## Installation

For each database variant you will find a subfolder with the following 2 SQL files:

+ The `sakila-schema.sql` file contains all the CREATE statements required to create the structure of the Sakila database including tables, views, stored procedures, and triggers.

+ The `sakila-data.sql` file contains the INSERT statements required to populate the structure created by the `sakila-schema.sql` file, along with definitions for triggers that must be created after the initial data load.

## Database structure

An overview of the structure of the Sakila sample database can be found in the [MySQL documentation](https://dev.mysql.com/doc/sakila/en/sakila-structure.html).

## Can I help?

Yes, that would be much appreciated. The best way to help is to post a response via the Issue Tracker and/or submit a Pull Request.
