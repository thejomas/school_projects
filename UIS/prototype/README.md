# UIS prototype

## How to run the prototype
### Initialize the database
1. Create a database called `uis` or set the database in `__init__.py`.
2. Run `schema.sql` and `schema_ins.sql` in your database to create the tables needed for the app and to insert the test data.

    The following command can be used `$ psql -d databasename -f sql/schema.sql `

### Run the app
1. Install all the requirements needed: `$ pip install -r requirements.txt`.
2. Run the app: `$ python run.py`.
