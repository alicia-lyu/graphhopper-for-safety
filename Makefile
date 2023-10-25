serve: wisconsin-latest.osm.pbf
	mvn clean install -DskipTests
	java -jar web/target/graphhopper-web-*.jar server config-example.yml	

wisconsin-latest.osm.pbf:
	wget https://download.geofabrik.de/north-america/us/wisconsin-latest.osm.pbf