![image](https://github.com/intersystems-ib/workshop-quiniela/assets/108397870/c73e9a55-985d-4487-bd33-4afb832d350c)# workshop-quiniela
Example about a project based on InterSystems IRIS and IntegratedML capabilities as back-end to get predictions about football matches of spanish league and an Angular project as front-end

You can find more in-depth information in https://learning.intersystems.com.


# What do you need to install? 
* [Git](https://git-scm.com/downloads) 
* [Docker](https://www.docker.com/products/docker-desktop) (if you are using Windows, make sure you set your Docker installation to use "Linux containers").
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visual Studio Code](https://code.visualstudio.com/download) + [InterSystems ObjectScript VSCode Extension](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript)

# Setup
Build the image we will use during the workshop:

```console
$ git clone https://github.com/intersystems-ib/workshop-quiniela
$ cd workshop-quiniela
$ docker-compose build
```

# Introduction

## What is "Quiniela"?

The Quiniela is a popular game in Spain, during many year sport bets were forbidden in Spain and Quiniela was the only game allowed. This game is based on Spanish Football/Soccer league (First and Second division). The Quiniela ticket has 15 matches (10 of First Division and 5 of Second Division) and the player has to check one of three options, selecting which team is going to be the winner of the match. 1 for the local team 2 for the visitor team or X for a draw (also known as "The 1X2 game").
![image](https://github.com/intersystems-ib/workshop-quiniela/assets/108397870/d7ffeab2-2166-41ed-9550-15658138a115)


## How does this project work?

This project is designed as a common web application with a backend developed on InterSystems IRIS Community edition and a frontend developed on Angular.

## Backend

As we said before, our backend is developed on InterSystems IRIS with IntegratedML technologies. The backend is responsible for:
* Get historic results of Spanish League from an external web using webscrapping with [Embedded Python](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=AFL_epython) capabilities.
* Prepare the data get from the external web to be used by the prediction model.
* Create model and train with the prepared data using the [IntegratedML](https://docs.intersystems.com/iris20232/csp/docbook/Doc.View.cls?KEY=GIML_Intro) capabilities.
* Receive and manage REST calls from the front-end.
* Generate predictions for the matches.
* Provide a JWT in order to securize the communication between frontend and backend.

## Frontend

Developed on Angular provides an easy to use user interface sending REST calls to the backend and receiving and managing the responses.

# Testing the project 
* Run the containers to deploy the backend and the frontend:
```
docker-compose up -d
```
Automatically an IRIS instance will be deployed and a production will be configured and run available to import data to create the prediction model and train it.

* Open the [Management Portal](http://localhost:52774/csp/sys/%25CSP.Portal.Home.zen?$NAMESPACE=QUINIELA).
* Login using the default `superuser`/ `SYS` account.
* Click on [Production](http://localhost:52774/csp/QUINIELA/EnsPortal.ProductionConfig.zen) to access the production that we are going to use. You can access also through *Interoperability > User > Configure > Production*.

Now you can check the frontend:
* Open the main page from this [URL](http://localhost:4200).
  ![image](https://github.com/intersystems-ib/workshop-quiniela/assets/108397870/ca443397-1314-4da9-ae04-743ea353d34d)

* Login using `superuser` / `SYS` account.
* Click on the icon on the upper left of the screen and check the options of the menu.
  ![image](https://github.com/intersystems-ib/workshop-quiniela/assets/108397870/bf3aa240-f235-4ecd-a9a3-512959402b74)

* Click on Data management and follow the arrows: Launch import -> Launch preparation -> Launch training. Wait for the end of each step.
* Now open the Menu again and click on Result prediction.
* You can add all the matches and see the prediction.
![image](https://github.com/intersystems-ib/workshop-quiniela/assets/108397870/187342e7-deed-4df4-a586-360782ee52b4)
* You can keep the data updated adding the real result clicking on the match and introducing the result:
![image](https://github.com/intersystems-ib/workshop-quiniela/assets/108397870/1ed2d730-d327-452b-806d-1fa6ed1d964d)


