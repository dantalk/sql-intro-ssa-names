.DEFAULT_GOAL := help
.PHONY : clean help ALL


help:
	@echo 'read Makefile; run `make ALL` to do all tasks'

ALL: compile


compile: data/compiled/ssa-national.csv

data/compiled/ssa-national.csv: unpack
	@echo "Compiling all yob*.txt into single file..."
	@echo "Number of yob files:"
	find data/collected/ssa-national/yob*.txt | wc -l

	mkdir -p data/compiled
	echo "year,name,sex,count" > data/compiled/ssa-national.csv
	rg '^\w+' --no-heading --no-line-number data/collected/ssa-national/*.txt \
	    | rg '(\d{4})\.txt:(\w+),([MF]),(\d+)' -or '$1,$2,$3,$4' \
	    >> data/compiled/ssa-national.csv

	@echo 'Number of lines compiled:'
	wc -l data/compiled/ssa-national.csv

unpack: data/collected/ssa-national/yob2018.txt

data/collected/ssa-national/yob2018.txt: fetch
	unzip -q -o data/collected/ssa-national.zip -d data/collected/ssa-national

	@echo "Number of yob files:"
	find data/collected/ssa-national/yob*.txt | wc -l

	@echo 'Number of lines collected:'
	cat data/collected/ssa-national/yob*.txt | wc -l



fetch: data/collected/ssa-national.zip
data/collected/ssa-national.zip:
	mkdir -p data/collected
	curl -Lo data/collected/ssa-national.zip https://www.ssa.gov/oact/babynames/names.zip

