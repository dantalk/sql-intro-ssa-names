# SQLite+DB Browser intro using SSA baby names

Data comes from here:
https://www.ssa.gov/oact/babynames/limits.html

https://www.ssa.gov/oact/babynames/names.zip

## Data downloads

- Mirror of national names.zip: [ssa-national.zip](https://raw.githubusercontent.com/dantalk/sql-intro-ssa-names/master/data/collected/ssa-national.zi)
- Compilation of all national data into one CSV file: [ssa-national-all-years.csv](https://raw.githubusercontent.com/dantalk/sql-intro-ssa-names/master/data/compiled/ssa-national-all-years.csv)
- SQLite file of national data, years 1950-2010: [ssanames-1950-2010.sqlite](https://raw.githubusercontent.com/dantalk/sql-intro-ssa-names/master/data/packaged/ssanames-1950-2010.sqlite) – this is what we'll be using for the exercise (it's small enough to save on Github, i.e. <100MB)

## Development

To rebuild the data:

```sh
$ make clean && make
```


```
mkdir -p data/published

sqlite3 data/published/foo.sqlite <<SQL_HEREDOC
.bail on
.headers on
.mode csv
.import data/compiled/ssa-national.csv national

SELECT * FROM national LIMIT 10;

SQL_HEREDOC


```
