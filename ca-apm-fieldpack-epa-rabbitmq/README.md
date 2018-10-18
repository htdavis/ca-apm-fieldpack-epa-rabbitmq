# EPAgent Plugins for RabbitMQ (1.1)

This is a series of plugins for monitoring RabbitMQ.

RabbitMQ_Bindings.pl - gathers binding statistics.  
RabbitMQ_Channels.pl - gathers channel statistics.  
RabbitMQ_Connections.pl - gathers connection statistics.  
RabbitMQ_Exchanges.pl - gathers exchange statistics.    
RabbitMQ_Nodes.pl - gathers node statistics.  
RabbitMQ_Queues.pl - gathers queue statistics.  

Tested with CA APM 9.1+ EM, EPAgent 9.1+, Infrastructure Agent 10.7, RabbitMQ 3.7.0, Perl 5.10.1, and Python 2.7.6.

## Known Issues
The plugins all use a CPAN module called File::Slurp. If this is not installed with your distro, or cannot install it, then locate the following two lines and comment them out:

    use File::Slurp
    @arrayResults = read_file(File::Spec->catfile  

If you would like to install the module on CentOS/RHEL, use the following command:

    [sudo] yum -y install perl-File-Slurp
    
If you are on Windows, use Strawberry Perl's CPAN client or ActivePerl's PPM client.

It has been reported and verified that the output from newer versions of RabbitMQ has changed.  
You will need to validate the new output against the ones used to create the plugins.

# Licensing
FieldPacks are provided under the Apache License, version 2.0. See [Licensing](https://www.apache.org/licenses/LICENSE-2.0).


# Installation Instructions

Follow the instructions in the EPAgent guide to setup the agent.

Add stateless plugin entries to &lt;epa_home&gt;/IntroscopeEPAgent.properties.

	introscope.epagent.plugins.stateless.names=BINDINGS,CHANNELS,CONNECTIONS,EXCHANGES,NODES,QUEUES (can be appended to a previous entry)
	introscope.epagent.stateless.BINDINGS.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Bindings.pl --host=HOST_OR_IP_ADDR --port=12345 --user=USERNAME --pswd=PASSWORD
	introscope.epagent.stateless.BINDINGS.delayInSeconds=900
	introscope.epagent.stateless.CHANNELS.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Channels.pl --host=HOST_OR_IP_ADDR --port=12345 --user=USERNAME --pswd=PASSWORD
	introscope.epagent.stateless.CHANNELS.delayInSeconds=900
	introscope.epagent.stateless.CONNECTIONS.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Connections.pl --host=HOST_OR_IP_ADDR --port=12345 --user=USERNAME --pswd=PASSWORD
	introscope.epagent.stateless.CONNECTIONS.delayInSeconds=900
	introscope.epagent.stateless.EXCHANGES.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Exchanges.pl --host=HOST_OR_IP_ADDR --port=12345 --user=USERNAME --pswd=PASSWORD
	introscope.epagent.stateless.EXCHANGES.delayInSeconds=900
	introscope.epagent.stateless.NODES.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Nodes.pl --host=HOST_OR_IP_ADDR --port=12345 --user=USERNAME --pswd=PASSWORD
	introscope.epagent.stateless.NODES.delayInSeconds=900
	introscope.epagent.stateless.QUEUES.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Queues.pl --host=HOST_OR_IP_ADDR --port=12345 --user=USERNAME --pswd=PASSWORD
	introscope.epagent.stateless.QUEUES.delayInSeconds=900

Follow these instructions to deploy the plugins to APMIA without an ACC bundle:

Create a subfolder and copy in the contents of _post-10.5_ to &lt;apmia_home&gt;/extensions.  
Edit &lt;apmia_home&gt;/extensions/Extensions.profile  
* Add your extension to the list in property  
introscope.agent.extensions.bundles.boot.load
	
# Usage Instructions
Follow the instructions to download a copy of the Management Commandline Tool, [rabbitmqadmin.py](https://www.rabbitmq.com/management-cli.html).  
Place the file in the directory where your plugins are located.  

Start the EPAgent using the provided control script in &lt;epa_home&gt;/bin.  

## How to create an ACC bundle for Infrastructure Agent (APMIA)
The files located in the 'post-10.5' folder are already preconfigured for creating a bundle. Place a copy of your CLI file in the _data_ folder.  
Delete 'readme.txt' in this folder.   
Obtain a copy of 'PrintMetric.pm' from your EPAgent archive and place in the 'lib/perl/Wily'.  
Delete 'readme.txt' in this folder.  
Update 'description.md' and 'bundle.json' in the _metadata_ folder.  
Create a ZIP file of the 'post-10.5' contents, ensuring you don't include the parent folder.  
Upload the ZIP file to your ACC instance.

## How to debug and troubleshoot the field pack
Update the root logger in IntroscopeEPAgent.properties/IntroscopeAgent.profile from INFO to DEBUG, then save. No need to restart the JVM.
You can also manually execute the plugins from a console and use perl's built-in debugger.

Carefully read each plugin's POD section for details on how to run the plugins in debug mode. If you are using a newer version than what was tested, it's more than likely that the vendor has increased/decreased the number of columns in the TSV output. It will be apparent when you compare the output to the program. Adjust the program accordingly.

If you still need assistance after testing, please open a new discussion on [CA APM DEV](http://bit.ly/caapm_dev).

## Future work
Anybody can contribute to this project over GitHub, e.g. changing a property in a configuration file on every EM, backup/copy configuration or data files, restarting a process, ...

## Support
This document and associated tools are made available from CA Technologies as examples and provided at no charge as a courtesy to the CA APM Community at large. This resource may require modification for use in your environment. However, please note that this resource is not supported by CA Technologies, and inclusion in this site should not be construed to be an endorsement or recommendation by CA Technologies. These utilities are not covered by the CA Technologies software license agreement and there is no explicit or implied warranty from CA Technologies. They can be used and distributed freely amongst the CA APM Community, but not sold. As such, they are unsupported software, provided as is without warranty of any kind, express or implied, including but not limited to warranties of merchantability and fitness for a particular purpose. CA Technologies does not warrant that this resource will meet your requirements or that the operation of the resource will be uninterrupted or error free or that any defects will be corrected. The use of this resource implies that you understand and agree to the terms listed herein.

Although these utilities are unsupported, please let us know if you have any problems or questions by adding a comment to the CA APM Community Site area where the resource is located, so that the Author(s) may attempt to address the issue or question.

Unless explicitly stated otherwise this extension is only supported on the same platforms as the APM core agent. See [APM Compatibility Guide](http://www.ca.com/us/support/ca-support-online/product-content/status/compatibility-matrix/application-performance-management-compatibility-guide.aspx).

### Support URL
https://github.com/htdavis/ca-apm-fieldpack-epa-rabbitmq/issues

# Contributing
The [CA APM Community](https://communities.ca.com/community/ca-apm) is the primary means of interfacing with other users and with the CA APM product team.  The [developer subcommunity](https://communities.ca.com/community/ca-apm/ca-developer-apm) is where you can learn more about building APM-based assets, find code examples, and ask questions of other developers and the CA APM product team.

If you wish to contribute to this or any other project, please refer to [easy instructions](https://communities.ca.com/docs/DOC-231150910) available on the CA APM Developer Community.

## Categories

Middleware/ESB


# Change log
Changes for each version of the field pack.

Version | Author | Comment
--------|--------|--------
1.0 | Hiko Davis | First bundled version of the field packs.
1.1 | Hiko Davis | Updated for 3.7.0
