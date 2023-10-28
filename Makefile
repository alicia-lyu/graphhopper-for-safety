STATES = alabama alaska arizona arkansas california colorado connecticut delaware florida georgia idaho illinois indiana iowa kansas kentucky hawaii louisiana maine maryland massachusetts michigan minnesota mississippi missouri montana nebraska nevada new-hampshire new-jersey new-mexico new-york north-carolina north-dakota ohio oklahoma oregon pennsylvania rhode-island south-carolina south-dakota tennessee texas utah vermont virginia washington west-virginia wisconsin wyoming

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