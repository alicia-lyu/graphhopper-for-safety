serve: get-data
	mvn clean install -DskipTests
	java -jar web/target/graphhopper-web-*.jar server config-example.yml	

get-data:
	wget https://download.geofabrik.de/north-america/us/wisconsin-latest.osm.pbf