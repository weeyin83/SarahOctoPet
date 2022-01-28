# This repository

This repository contains the code for the [OctoPetShop](#octopetshop) application.  That can be used to demo deployments within Octopus Deploy. 

This repository also contains the Azure Bicep template files that can be used to deploy the infrastructure that is needed to host the OctoPetShop application. 

You can find information explaining more about the repository, bicep templates, deployment process etc within this readme.   If you have any questions or issues please do use the [Issues template](#issue-templates). 

You can view this all being used and in action in this [demo Octopus Deploy instance](https://webinar.octopus.app/app#/Spaces-242). 

**Table of Contents:** 
- [OctoPetShop](#octopetshop)
- [GitHub Actions Workflow](#github-actions-workflow)
- [Bicep Deployment Process](#bicep-deployment-process)
    - [Create the Azure Resource Group](#create-azure-resource-group)
    - [Deploy Bicep Template](#deploy-bicep-instructions)
- [Variables](#variables)

# OctoPetShop
Octopus Pet Shop Example Web app written in .NET Core.  This solution consists of:
 - Octopus Pet Shop Web front end
 - Product Service
 - Shopping Cart Service
 - Database project using Dbup

This is a customized fork from the [Octopus Deploy Sample](https://github.com/OctopusSamples/OctoPetShop). 

[![OctoPetShopAppBuild](https://github.com/weeyin83/SarahOctoPet/actions/workflows/octopetshopbuild.yml/badge.svg?event=push)](https://github.com/weeyin83/SarahOctoPet/actions/workflows/octopetshopbuild.yml)
[![OctoPetShopBicepBuild](https://github.com/weeyin83/SarahOctoPet/actions/workflows/biceppush.yml/badge.svg?branch=main)](https://github.com/weeyin83/SarahOctoPet/actions/workflows/biceppush.yml)

# GitHub Actions Workflow
 Within the .github/workflows folder you will find a GitHub Actions Workflow file entitled 'octopetshopbuild.yml'.  This workflow builds the .NET packages, and then pushes them to an Octopus instance ready for deployment to the relevant infrastructure. 

The 'biceppush.yml' GitHub Actions Workflow file takes the Azure Bicep module and template files within the Bicep folder.  Packs them into a ZIP file and then pushes them to the Octopus Deploy server ready for deployment. 

# Bicep Deployment Process

To deploy Bicep template files from Octopus Deploy to Azure we need to package them inside a ZIP file. Once in a ZIP file we can upload them into the Octopus Library.  We deploy our Bicep files using a Octopus Runbook. 

## Create Azure Resource Group
As with any deployment of resources to Azure we need to start with the creation of an Azure resource group.

We use the following command:

```bash
az group create -l $OctopusParameters["Azure.Location"] -n $OctopusParameters["Azure.Environment.ResourceGroup.Name"]
```

We pull in variables from the Octopus Variable library.

Within our Octopus Runbook we use the "Run an Azure Script" step for this part.

## Deploy Bicep instructions
To deploy the Bicep modules and template file we use an Azure Script step within an Octopus Runbook.

We associate the ZIP file that we created with our Bicep files. And run the following:

```powershell
# Reference the package with the Bicep files
$filePath = $OctopusParameters["Octopus.Action.Package[OctoBicepFiles].ExtractedPath"]

# Change Directory to extracted package
cd $filePath

# Set the deployment name
$today=Get-Date -Format "dd-MM-yyyy"
$deploymentName="OctoPetShopInfra"+"$today"

# Deply the Bicep template files
New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $OctopusParameters["Azure.Environment.ResourceGroup.Name"] -TemplateFile octopetshop.bicep -planName $planName -planSku $planSku -sku $sku -productwebSiteName $OctopusParameters["Project.ProductService.Name"] -shoppingwebSiteName $OctopusParameters["Project.ShoppingCartService.Name"] -frontwebSiteName $OctopusParameters["Project.WebApp.Name"] -startFWIpAddress $startFWIpAddress -endFWIpAddress $endFWIpAddress -databaseName $OctopusParameters["Project.Database.Name"] -sqlServerName $OctopusParameters["Project.Database.Server"] -sqlAdministratorLogin $OctopusParameters["Project.Database.Admin.Username"] -sqlAdministratorLoginPassword $OctopusParameters["Project.Database.Admin.Password"]
````
During the deployment command we are passing in the variables that the templates need to deploy. 

Within our Octopus Runbook we use the "Run an Azure Script" step for this part. When configuring this step we ensure we are selecting the package with the Bicep files in as part of this step. 

![Our Bicep Runbook](/images/biceprunbook.png)

Our runbook, creates the Resource Group, deploys the Bicep files and then registers the new [Web Apps as deployment targets](https://octopus.com/docs/octopus-rest-api/examples/deployment-targets/add-azure-web-app) within Octopus Deploy ready for our application to deploy to them. 

# Variables 
**Location** - This is the Azure region your resources will be deployed to.

**Resource Group** - This is the name of the Azure Resource Group you will deploy your infrastructure to.

**Plan Name** - This is the name of your Azure App Service Plan.

**Plan Sku** - This is the SKU for your Azure App Service Plan.  This should be S1, B1, P1v2 or something similar. 

**Sku** - This is the SKU for your Azure App Service Plan.  This should be Standard, Premium or equivalent. 

**Product Web Site Name**- This is the name of the Azure Web App that will be used for the deployment of your Product Web Site.

**Shopping Web Site Name** - This is the name of the Azure Web App that will be used for the deployment of your Shopping Cart Web Site.

**Front Web Site Name** - This is the name of the Azure Web App that will be used for the deployment of your Front end Web Site.

**Start FW IP Address** - This is the starting range of the IP address that will be for the SQL Server Firewall Rule.

**End FW IP Address** - This is the end range of the IP address that will be for the SQL Server Firewall Rule.

**Database Name** - This is the name of the database that will be created inside your SQL Server.

**SQL Server Name** - This is the name of your SQL Server.

**SQL Administrator Login** - This is the username for your SQL Server.

**SQL Administrator Login Password** - This is the password for your SQL Server.

 # Issue Templates
 Within the .github/ISSUE_TEMPLATES folder I have created some GitHub issue templates to, hopefully make it easier for you to reach out with questions or concerns relating to this repo. If you have a question or concern click [here](https://github.com/weeyin83/SarahOctoPet/issues/new/choose) and raise an issue. 
