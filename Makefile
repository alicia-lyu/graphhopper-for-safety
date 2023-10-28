serve: states.osm.pbf
	mvn clean install -DskipTests
	java -jar web/target/graphhopper-web-*.jar server config-example.yml

STATES = texas wisconsin minnesota illinois georgia arizona colorado massachusetts
PBF_FILES = $(addsuffix -latest.osm.pbf,$(STATES))

states.osm.pbf: $(PBF_FILES)
	@$(MAKE) recursive_merge FILES="$(PBF_FILES)" OUTPUT=states.osm.pbf
	$(foreach pbf_file,$(PBF_FILES),rm $(pbf_file))

recursive_merge: osmosis
	$(eval FIRST := $(word 1, $(FILES)))
	$(eval SECOND := $(word 2, $(FILES)))
	@if [ "$(SECOND)" != "" ]; then \
		bin/osmosis --read-pbf $(FIRST) --read-pbf $(SECOND) --merge --write-pbf temp.osm.pbf; \
		$(MAKE) recursive_merge FILES="temp.osm.pbf $(wordlist 3, $(words $(FILES)), $(FILES))" OUTPUT=$(OUTPUT); \
	else \
		mv $(FIRST) $(OUTPUT); \
		rm -f temp.osm.pbf; \
	fi

%-latest.osm.pbf:
	wget https://download.geofabrik.de/north-america/us/$*-latest.osm.pbf

clean individual states:
	rm -f *-latest.osm.pbf

osmosis:
	mkdir osmosis
	cd osmosis
	wget https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz
	tar xvfz osmosis-0.48.3.tgz
	rm osmosis-0.48.3.tgz
	chmod a+x bin/osmosis
	cd ..

# serve wisconsin: wisconsin-latest.osm.pbf
# 	mvn clean install -DskipTests
# 	java -Ddw.graphhopper.datareader.file=wisconsin-latest.osm.pbf -jar web/target/graphhopper-web-*.jar server config-example.yml

# us-latest.osm.pbf: 
# 	wget https://download.geofabrik.de/north-america/us-latest.osm.pbf	

# wisconsin-latest.osm.pbf:
# 	wget https://download.geofabrik.de/north-america/us/wisconsin-latest.osm.pbf