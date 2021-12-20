param planName string
param planLocation string = resourceGroup().location
param planSku string ='F1'

resource asp 'Microsoft.Web/serverfarms@2020-12-01' = {
  name:planName
  location:planLocation
  properties: {
    reserved: true
  }
  sku: {
    name: planSku
  }
  kind: 'Linux'
}

output planId string = asp.id
