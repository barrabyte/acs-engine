# DGX Pre Provision Extension for ACS-Engine

## Introduction
The DGX Pre Provision extension for ACS-Engine does the following:

1. Overrides the default DNS domain name for the host. This is required where a
hybrid DNS solution is enabled. In these cases Azure replaces the regular vnet
domain name (e.g. xxxxxxxxxxxxxxxxxxxxxxxxx.xx.internal.cloudapp.net) with reddog.microsoft.com. This
breaks DNS lookups of the localhost name and other names within the vnet.

In order to get the vnet dns suffix, use the following command on an actual NIC already present in the vnet:

```
az network nic show \
  --name <nic-name> \
  -g <resource-group-name> \
  -o tsv \
  --query dnsSettings.internalDomainNameSuffix
```

2. Installs the medplus.com Certificate of Authority on each host. This allows hosts
to access the MedPlus Artifactory Repo.

Below are snippets of code that can be used on the acs-engine json definition file
to install the extension. Remember to the replace values in the extensionParameters field with 
the actual values. For example:

```json
"extensionParameters": "tpshvbxqtjburag05dodyj0ufd.yx.internal.cloudapp.net https://authority.medplus.com/mpcacert2011.pem /usr/local/share/ca-certificates/mpcacert2011.crt"
```

## Example Snippet for ACS-Engine ExtensionProfile

```json
"extensionProfiles": [
  {
    "name": "dgxPreProvision",
    "version": "v1",
    "extensionParameters": "domainName caSourceURI caTargetPath",
    "rootURL": "http://dgxk8scodedev.blob.core.windows.net/",
    "script": "dgxPreProvision.sh"
  }
]
```

## Example Snippet for ACS-Engine Master and Pool Profiles

```json
"preProvisionExtension": {
  "name": "dgxPreProvision",
  "singleOrAll": "All"
}
```

## How To Build
An ACS-Engine Pre Provision extension is injected in the cloud-init process whena node is creaed. The files are downloaded from an Azure storage account (using the value of the rootURL parameter in the extension profile definition). The files could be hosted in other locations, however downloading from other sources (e.g. github) proved tempremental in testing so a storage account was used. 

If a storage account is used, then blob container should be configured for global read access as the node will not have access to storage account keys. ACS-Engine expects the first level under the root URL to be called "extensions". In the above example, a container called "extensions" was used (as this is the next level). If another container name is required, this name must be added to the rootURL (e.g. http://stoarge-account-name.blob.core.windows.net/container-name/ ) and the next level must be called "extensions".

Under the "extensions" level the a folder with the name of the extension (e.g. dgxPreProvision), following by the value of version ("e.g. "v1"). under the version level, the extension files must be placed. 

Notes
-----
Only 1 Pre Provision Extension may be specified. 

An ACS-Engine PRE provision extension requires the Script file and Supported Orchestrator files only. The script file is injected into the cloud-init process.

ACS-Engine POST provision extensions are not injected into cloud-init, instead they are injected in the ARM template deployment process. These extensions require a Script, Supported Orchestrator, ARM Template and ARM Template link files.
