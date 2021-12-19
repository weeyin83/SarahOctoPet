# OctoPetShop
Octopus Pet Shop Example Web app written in .NET Core.  This solution consists of:
 - Octopus Pet Shop Web front end
 - Product Service
 - Shopping Cart Service
 - Database project using Dbup

This is a customised fork from the [Octopus Deploy Sample](https://github.com/OctopusSamples/OctoPetShop). 

# GitHub Actions Workflow
 Within the .github/workflows folder you will find a GitHub Actions Workflow file entitled 'octopetshopbuild.yml'.  This workflow builds the .NET packages, and then pushes them to an Octopus instance ready for deployment to the relevant infrastructure. 
