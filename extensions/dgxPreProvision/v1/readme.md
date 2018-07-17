# DGX Pre Provision Extension for ACS-Engine

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