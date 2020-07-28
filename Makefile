.DEFAULT_GOAL := ALL
.PHONY : clean help ALL


help:
	@echo 'read Makefile; run `make ALL` to do all tasks'

ALL: compile


clean:
	# Deleting data/
	[ -d ./data/ ] && rm -r ./data/



compile: compile_national compile_samples


compile_samples: data/compiled/ssa-national-sample.csv

data/compiled/ssa-national-sample.csv: data/compiled/ssa-national.csv
	###########################
	# Compiling national sample
	cat $< \
		| xsv search '\d{3}0' -s year \
		> $@
		wc -l $@


compile_national: data/compiled/ssa-national.csv

data/compiled/ssa-national.csv: data/collected/ssa-national/yob2018.txt
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

