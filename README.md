# ArgumentMapper Domain

## Development Environment Setup

### Install SpecFlow

You can safely skip this section if you do not intend to edit SpecFlow
specifications.

This project uses SpecFlow 3. To use, you will need to install a Visual Studio
extension from a preview repository. Once the full version of SpecFlow 3 is
released, this will no longer be necessary. Follow the instructions in this
document to install the extension:

https://specflow.org/2018/specflow-3-public-preview-now-available/

### Common Environment Setup

### Database Setup

From the scripts folder:

Run SQL Server:

```
.\dev.ps1
```

Rebuild database: 

```
.\rebuilddb.ps1 local local
```

### Other

.\buid.ps1 -target Release 


