param buildNumber string
param location string = resourceGroup().location

@minLength(3)
@maxLength(24)
@description('The name of the storage account')

param planName string
param planSku string
param productwebSiteName string
param frontwebSiteName string
param shoppingwebSiteName string
param databaseName string
param sqlServerName string
param sqlAdministratorLogin string
param sqlAdministratorLoginPassword string
param startFWIpAddress string
param endFWIpAddress string

// App service plan
module aspModule 'AppServicePlan/template.bicep' = {
  name:'appServicePlan-${buildNumber}'
  params:{
    planName:planName
    planLocation:location
    planSku:planSku
  }
}

// App service deployment
module productserviceweb 'WebApp/template.bicep' = {
  name:'productservicewebapp-${buildNumber}'
  params:{
    webSiteName:productwebSiteName
    location:location
    planName:planName
  }
  dependsOn:[
    aspModule
  ] 
}

// App service deployment
module frontwebapp 'WebApp/template.bicep' = {
  name:'frontwebapp-${buildNumber}'
  params:{
    webSiteName:frontwebSiteName
    location:location
    planName:planName
  }
  dependsOn:[
    aspModule
  ] 
}

// App service deployment
module shoppingcartweb 'WebApp/template.bicep' = {
  name:'shoppingcartwebapp-${buildNumber}'
  params:{
    webSiteName:shoppingwebSiteName
    location:location
    planName:planName
  }
  dependsOn:[
    aspModule
  ] 
}

// SQL Server and database deployment
module database 'SQLServer/template.bicep' = {
  name:'sqlserver-${buildNumber}'
  params:{
    startFWIpAddress:startFWIpAddress
    endFWIpAddress:endFWIpAddress    
    databaseName:databaseName
    sqlServerName:sqlServerName
    sqlAdministratorLogin:sqlAdministratorLogin
    sqlAdministratorLoginPassword:sqlAdministratorLoginPassword
  }
}
