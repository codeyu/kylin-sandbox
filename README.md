# Kylin Sandbox

## Goal
To provide a ready-to-go Docker sandbox for local development using Apache Kylin.

To do this, we use the Hortonworks HDP 2.6.1 sandbox as a base Docker image. HDP includes all of the required Apache technologies for powering Kylin.

Building on that, we then construct a new Dockerfile that downloads and installs Apache Kylin 2.1.0 into the image.

That's it -- this project is a very simple wrapper.

## Running Kylin

### Prerequisites

- Docker installed

### Step 1 - Download and Install Hortonworks HDP Docker Image
First follow the instructions [here](https://hortonworks.com/tutorial/sandbox-deployment-and-install-guide/section/3/) to install the HDP image locally.

As a sanity check, you should now have an image named `sandbox-hdp` when you run `docker images` from your command line.

### Step 2 - Build the Kylin Sandbox Image
1. `cd` into `kylin-sandbox` on your machine
2. `docker build -t kylin-sandbox .` (this will take a little while, as the HDP base image is very large)

### Step 3 - Run the Kylin Sandbox Container
1. Run `./start_kylin_sandbox.sh`

This script is adapted from the standard HDP sandbox start script in order to map port `7070` on the host, start Apache HBase (which is necessary for Kylin but does not start by default in HDP), and finally start Apache Kylin.

Once this script is done running, you should be able to access the following:

- Ambari ([http://localhost:8080](http://localhost:8080))
    - Username: admin
    - Password: 4o12t0n
- Kylin ([http://localhost:7070/kylin](http://localhost:7070/kylin))
    - Username: ADMIN
    - Password: KYLIN
