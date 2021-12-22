param planName string
param planLocation string = resourceGroup().location
param planSku string
param sku string

resource asp 'Microsoft.Web/serverfarms@2020-12-01' = {
  name:planName
  location:planLocation
  kind: 'Windows'
  sku: {
    tier: sku
    name: planSku
  }
}

output planId string = asp.id
