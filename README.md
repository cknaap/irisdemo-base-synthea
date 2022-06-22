# firely.synthea

Container for running synthea.

Repository: https://github.com/FirelyTeam/firely.synthea

This is based on https://github.com/intersystems-community/irisdemo-base-synthea.
I (Christiaan) added powershell scripts `build_synthea.ps1` & `build.ps1` to run the whole thing on Windows.

The scripts are mainly use to build the Docker image.
After building it, you can use the image to run Synthea without installing it (and Java) locally.

## Pull readymade image

If you can use a version that is prebuilt, you don't need this repository at all :-) 
I  registered the built image for Synthea 3.0.0 in the FirelyTeam docker repository.
By the time you read this, other versions may be available. Check (the repository)[https://portal.azure.com/#view/Microsoft_Azure_ContainerRegistries/RepositoryBlade/id/%2Fsubscriptions%2F888f4097-c254-483a-9596-a5863a11c4a9%2FresourceGroups%2Fbuildserver%2Fproviders%2FMicrosoft.ContainerRegistry%2Fregistries%2Ffirely/repository/firely%2Fsynthea].

You may need to log in first:
```
docker login --username USER_NAME --password PASSWORD firely.azurecr.io
```

Then you can pull it:
```
docker pull firely.azurecr.io/firely/synthea:v3.0.0
```

## Build an image yourself

- set the version of Synthea you want to use in the `VERSION` file (use the corresponding (tag from the synthea repository)[https://github.com/synthetichealth/synthea/tags]). 
(This will also be the tag of the image to build)
- run `build.ps1`, which will
	- run `build_synthea.ps1`, which:
		- will retrieve (the same) version from `VERSION`
		- clone the synthea repository at this tag
		- build Synthea binaries
		- bundle them in `synthea_dist/synthea.tar`
	- build an image of the tar file as specified in the `Dockerfile`
- The dockerfile:
	- maps the `/output` directory for the generated output
	- has `synthea/bin/synthea` as entrypoint, so you can use the container like you would use the `synthea.exe`.

Check the result:

```powershell
docker image ls
```

## Generate resources with the container:

This example will generate 25 Patient records (including all resources for their health history), in FHIR R4 ndjson (Bulk Data Export) format. It also skips the US-Core profiles, useful if you want valid resources w.r.t just the Core FHIR spec.

```powershell
docker run --rm -v $PWD/output:/output --name synthea-docker firely/synthea:v3.0.0 -p 25 `
--exporter.fhir.bulk_data true `
--exporter.fhir.transaction_bundle false `
--exporter.fhir.use_us_core_ig false
```

As the ./output directory is mounted to the container for the generated output, you can find the resource here:
```powershell
dir ./output/fhir
```

You can find all the `--exporter*` settings in the (synthea repo)[https://github.com/synthetichealth/synthea/] in `/src/main/resources/synthea.properties` ((direct link)[https://github.com/synthetichealth/synthea/blob/master/src/main/resources/synthea.properties]).

## Push the image to the Firely docker repository:

This step is optional, but can be useful for e.g. new major versions of Synthea.

You may have to login first, see above.

```powershell
docker push firely.azurecr.io/firely/synthea:v3.0.0
```
