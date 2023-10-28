STATES = texas wisconsin minnesota illinois georgia arizona colorado massachusetts

$(STATES): %: %-latest.osm.pbf
	touch current_state.txt
	@if [ "$$(cat current_state.txt)" != "$*" ]; then \
		rm -rf graph-cache; \
	fi
	mvn clean install -DskipTests
	echo $* > current_state.txt
	java -Ddw.graphhopper.datareader.file=$*-latest.osm.pbf -jar web/target/graphhopper-web-*.jar server config-example.yml

%-latest.osm.pbf:
	wget https://download.geofabrik.de/north-america/us/$*-latest.osm.pbf