#!/bin/sh

# next 2 variables need to adapt to your system
settings=setting_path
url=repository_url

for pom in `find $settings -name *.pom`
do
	echo "deploy $pom"
	if [ -f "${pom%%.pom}.jar" ]; then
	  mvn deploy:deploy-file -s $settings -Durl=$url -Dfile="${pom%%.pom}.jar" -DgeneratePom=false -DpomFile="$pom" -Dpackaging=jar &
	else
	  mvn deploy:deploy-file -s $settings -Durl=$url -Dpackaging=pom -Dfile="$pom" -DgeneratePom=false -DpomFile="$pom" &
	fi
    sleep 2
done

wait