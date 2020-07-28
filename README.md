# SQLite+DB Browser intro using SSA baby names

Data comes from here:
https://www.ssa.gov/oact/babynames/limits.html

https://www.ssa.gov/oact/babynames/names.zip


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
