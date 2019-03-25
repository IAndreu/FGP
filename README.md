# Final Grade Project scripts

In this repository you will find all scripts developed during the FGP period. In principle, all the scripts are written in AMPL due to is the main programming language used for the implementation of integer linear programming models.

## Getting Started

These instructions will get you a copy of all the scripts and how to running on your local machine.


### Prerequisites

First, to have a copy of the scripts, click on clone/download.

### Installing

To be able to run the scripts without having to buy an AMPL lisence you can install a size-limited AMPL demo by following the given instructions in:

```
https://ampl.com/try-ampl/download-a-free-demo/
```

Or, you can use an online option:

```
https://ampl.com/try-ampl/start/
```


## Running the models

Once the previous steps are done, to run a particular model you will have to introduce the model.mod and the model.dat scripts by typing the commands:

```
options solver cplex; # to indicate which solver to use
model model.mod;
data model.dat;
solve;
```
In the case of the online ampl version, you only have to browse the model and data and click on submit.

## Author

Ignasi Andreu

