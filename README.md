# AWS EC2 Instance Connect Endpoint Node Execution Plugin for Rundeck

This plugin provides node executor and file-copier support to AWS EC2 via the Instance Connect Endpoint. 
Use this plugin if you must access servers via AWS EC2 Instance Connect Endpoint.

It is based upon the openssh Bastion Node Execution Plugin, and shares similar characteristics. This should make it easier to extend/tweak for more AWS parameters in the future if required.

The AWS CLI v2 must be installed and available to Rundeck. 

## Dry run mode
You can configure the plugin to just print the invocation string to the console.
This can be useful when defining the configuration properties.

## Plugin Configuration Properties
* AWS Access Key
* AWS Secret Key - set to storage path location in Rundeck Keystore
* AWS Default Region
* Node SSH Key  - set to storage path location in Rundeck Keystore
* SSH Options: Extra options to pass to the ssh command invocation. 
* Template ssh_config: Customize ProxyCommand and other flags. Consult the reference for [ssh_config(5)](https://linux.die.net/man/5/ssh_config) to learn about posible settings.
* Dry run? If set true, just print the command invocation that would be used but do not execute the command. This is useful to preview.

## Node Specific Configuration Attributes

* `ssh-key-storage-path` SSH key override - from the Rundeck Keystore.
* `ssh-ssh-config` - SSH extra options override
* `ssh-scp-config` - File Copier extra options override

## Configuration 

The plugin can be configured as a default node executor and file copier for a Project. Use the Simple Conguration tab to see the configuration properties. The page has a form with inputs to configure the connection

You can also modify the project.properties or use the API/CLI to define the plugin configuration.

The Plugin List page will describe the key names to set.

#### Customize the ssh_config 

You can define multiple lines using a trailing backslash and an indent on the following line.

Here is an example that defines ssh_config file. 

    project.plugin.NodeExecutor.openssh-bastion-host.node-executor.ssh_config=Host i-* \
      StrictHostKeyChecking no
      Port 22
      ProxyCommand aws ec2-instance-connect open-tunnel --instance-id @instance_id@
      IdentityFile @plugin.config.identity_file@

Here ssh_options are set.

    project.plugin.NodeExecutor.openssh-bastion-host.node-executor.ssh_options="-q -oCiphers=arcfour -oClearAllForwardings=yes"

Using Dry run, you might see output similar to this:

	[dry-run] +------------------------------------------+
	[dry-run] | ssh_config                               |
	[dry-run] +------------------------------------------+
	[dry-run] | Host i- *
	[dry-run] |   StrictHostKeyChecking no
	[dry-run] |   Port 22
	[dry-run] |   ProxyCommand aws ec2-instance-connect open-tunnel --instance-id i-123455678a01bcdefa
	[dry-run] |   IdentityFile /tmp/bastion.ssh-keyfile.prWLUyFU
	[dry-run] +------------------------------------------+
	[dry-run] ssh -q -oCiphers=arcfour -oClearAllForwardings=yes -F /tmp/ssh_config.zTr9j5KK -i /tmp/host1234.ssh-keyfile.4cjnI2qL ec2user@i-123455678a01bcdefa whoami
	Begin copy 18 bytes to node host1234: /etc/motd -> /tmp/motd
	[dry-run] +------------------------------------------+
	[dry-run] | ssh_config                               |
	[dry-run] +------------------------------------------+
	[dry-run] | Host *
	[dry-run] |   StrictHostKeyChecking no
	[dry-run] |   Port 22
	[dry-run] |   ProxyCommand aws ec2-instance-connect open-tunnel --instance-id i-123455678a01bcdefa
	[dry-run] |   IdentityFile /tmp/bastion.ssh-keyfile.XXXXX.WAlpZLNb
	[dry-run] | 
	[dry-run] +------------------------------------------+
	[dry-run] scp -q -oCiphers=arcfour -oClearAllForwardings=yes -F /tmp/ssh_config.XXXX.cosJ7xQ2 -i /tmp/host1234.ssh-keyfile.XXXXX.BOqYAKRu /etc/motd ec2-user@i-123455678a01bcdefa:/tmp/motd
	/tmp/motd
	Copied: /tmp/motd

## IAM Policies

The user will need to have the EC2InstanceConnect Permissions Policy

## EC2 Node Source Configuration

When using the AWS EC2 Node Resources Node Source, the following should be included in the Mapping Params to map the AWS instance ID to the hostname.

`hostname.selector=instanceId`

## Docker

An example Dockerfile is provided to install the AWS CLI v2 on the latest base Rundeck container from Dockerhub.

