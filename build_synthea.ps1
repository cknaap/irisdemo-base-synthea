echo "# "
echo "# BEGIN OF BUILD SYNTHEA FROM $PSScriptRoot"
echo "# "

Push-Location $PSScriptRoot

Remove-Item -Path ./synthea -Force -Recurse -ErrorAction SilentlyContinue

$VERSION = Get-Content -Path ./VERSION
$VERSION

git clone --depth 1 --branch $VERSION https://github.com/synthetichealth/synthea.git

mkdir ./synthea/.gradle
docker run -u gradle -v ${PWD}/synthea:/home/gradle/project -w /home/gradle/project gradle:latest gradle assemble

Remove-Item -Path ./synthea_dist -Force -Recurse -ErrorAction SilentlyContinue
mkdir ./synthea_dist
cp ./synthea/build/distributions/synthea.tar ./synthea_dist


ls -l
ls -l ./synthea_dist

Remove-Item -Path ./synthea -Force -Recurse

echo "# "
echo "# END OF BUILD SYNTHEA"
echo "# "
Pop-Location
