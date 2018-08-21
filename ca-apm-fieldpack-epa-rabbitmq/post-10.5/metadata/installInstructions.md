### EPAgent Plug-in Bundle for Infrastructure Agent

## ACC Installation

New agent package:

* Create a new agent package

* Choose Infrastructure Agent

* Choose this bundle to be included your new package

* Save your package

* Download your agent package archive

* Follow the instructions in the [wiki](https://docops.ca.com) to configure and start the agent as a service


Adding bundle to an existing package:

* Open your existing agent package

* Add this bundle to your package

* Save your package

* Deploy the updated package using the ACC Console or via API


Updating bundle in an existing package:

* Open your existing agent package

* Select this bundle and click on the _Replace_ button

* Make any updates you need to the bundle configuration

* Save your package

* Deploy the updated package using the ACC Console or via API


## Non-ACC Installation

* Download a compatible archive of the Infrastructure Agent from [CA Support](https://support.ca.com)

* Extract the archive to your target server

* Copy the bundle archive to _{ApmExtensionHome}/_

* Add Your bundle directory name to _{ApmExtensionHome}/Extensions.profile_

* Follow the instructions in the [wiki](https://docops.ca.com) to configure and start the agent as a service
