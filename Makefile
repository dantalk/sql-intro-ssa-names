.DEFAULT_GOAL := ALL
.PHONY : clean help ALL

help:
	@echo "This Makefile was tested on GNU Make 4.x. It requires ripgrep"

ALL: compile


clean:
	# Deleting data/
	[ -d ./data/ ] && rm -r ./data/


# ############
# SQL_IMPORT_DOC = \
# .bail on \n\
# .headers on \n\
# .mode csv \n\
# SELECT 1;\n


############


# data/compiled/ssa-national-sample.csv: data/compiled/ssa-national.csv
# 	###########################
# 	# Compiling national sample
# 	cat $< \
# 		| xsv search '(19[89]|20\d)[05]' -s year \
# 		> $@
# 		wc -l $@



# package: package_all


package_db: package_db_all_years

# package_sample_db: data/packaged/ssanames-1950-2010.sqlite
# data/packaged/ssanames-1950-2010.sqlite: data/packaged/ssanames-all-years.sqlite
# 	printf '%s\n' '.headers on' \
# 		'.mode csv' \
# 		'SELECT 1;' \
# 		| sqlite3 $<

package_db_excerpt: data/packaged/ssanames-1950-2010.sqlite


data/packaged/ssanames-1950-2010.sqlite: data/packaged/ssanames-all-years.sqlite
	cp $< $@
	sqlite3 $@ 'DELETE FROM national WHERE year < 1950 OR year > 2010;'
	sqlite3 $@ 'VACUUM;'

package_db_all_years: data/packaged/ssanames-all-years.sqlite
data/packaged/ssanames-all-years.sqlite: data/compiled/ssa-national-all-years.csv
	#########################################
	# Package the data into a sqlite database
	mkdir -p $(dir $@)

	cat scripts/package/import_all.sql | sqlite3 $@



compile: compile_national
compile_national: data/compiled/ssa-national-all-years.csv

data/compiled/ssa-national-all-years.csv: data/collected/ssa-national/yob2018.txt
	##############################################
	# Compile individual yob*.txt into single file
	# Number of yob*.txt files:
	find data/collected/ssa-national/yob*.txt | wc -l

	mkdir -p $(dir $@)
	echo "year,name,sex,count" > $@
	rg '^\w+' --no-heading --no-line-number \
		      --sort path  $(dir $<)*.txt \
	    | rg '(\d{4})\.txt:(\w+),([MF]),(\d+)' -or '$$1,$$2,$$3,$$4' \
	    >> $@


	head -n5 $@
	tail -n5 $@

	# Number of lines compiled:
	wc -l $@

unpack: data/collected/ssa-national/yob2018.txt

data/collected/ssa-national/yob2018.txt: data/collected/ssa-national.zip
	############################
	# Unzipping fetched zip file (and overwriting existing files)
	mkdir -p $(dir $@)
	tar -xmf $< --directory $(dir $@)


	# Number of yob*.txt files unpacked
	find $(dir $@)yob*.txt | wc -l

	# Number of lines in unpacked files
	cat $(dir $@)yob*.txt | wc -l



fetch: data/collected/ssa-national.zip

data/collected/ssa-national.zip:
	###############################
	# Downloading data from ssa.gov
	mkdir -p $(dir $@)
	curl -Lo $@ https://www.ssa.gov/oact/babynames/names.zip

