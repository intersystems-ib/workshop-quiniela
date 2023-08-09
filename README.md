# workshop-quiniela
Example about an IRIS production using IntegratedML capabilities to get predictions about football matches of spanish league

You can find more in-depth information in https://learning.intersystems.com.

New to IRIS Interoperability framework? Have a look at [IRIS Interoperability Intro Workshop](https://github.com/intersystems-ib/workshop-interop-intro).

# What do you need to install? 
* [Git](https://git-scm.com/downloads) 
* [Docker](https://www.docker.com/products/docker-desktop) (if you are using Windows, make sure you set your Docker installation to use "Linux containers").
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visual Studio Code](https://code.visualstudio.com/download) + [InterSystems ObjectScript VSCode Extension](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript)

# Setup
Build the image we will use during the workshop:

```console
$ git clone https://github.com/intersystems-ib/workshop-integratedml-csv
$ cd workshop-integratedml-csv
$ docker-compose build
```

# Example

The main purpose of this example is to get predictions about the stay of a patient with a hip fracture in the hospital. We are going to use real data about episodes in hospitals of the Castilla y León HealthService (SACYL) from Spain. For this example we are going to use the Record Mapper functionality of IRIS to import these data from CSV files. The creation and the training of the model will be executed the specific SQL queries available in IntegratedML

## Test Production 
* Run the containers we will use in the workshop:
```
docker-compose up -d
```
Automatically an IRIS instance will be deployed and a production will be configured and run available to import data to create the prediction model and train it.

* Open the [Management Portal](http://localhost:52774/csp/sys/UtilHome.csp).
* Login using the default `superuser`/ `SYS` account.
* Click on [Test Production](http://localhost:52774/csp/user/EnsPortal.ProductionConfig.zen?$NAMESPACE=MLTEST&$NAMESPACE=MLTEST&) to access the sample production that we are going to use. You can access also through *Interoperability > User > Configure > Production*.
* Click on CSVToEpisodeTrain Business Service and review the configuration, check the input folder. From Visual Studio Code copy *train-data.csv* and paste it into */shared/csv/trainIn*
* Do the same for CSVToEpisode Business Service, from Visual Studio Code copy *test-data.csv* and paste it into */shared/csv/newIn*
* Now you have the data ready for the model creation and training. Open the Business Operation *PredictStayEpisode.cls* from Visual Studio Code and review the queries used for the creation of the model and the training. As you can see, the model will be created the first time that the Business Operation is invoked from *RecordToEpisodeBPL.cls* .
* To start the predictions you only have to copy *messagesa01.hl7* file into */shared/hl7/in*, the production will start to consume ADT^A01 messages and generating predictions for each record, you can check it from the Messages log.
