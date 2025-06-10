## Provider's Example

# Configure the AWS Provider
provider "aws" {
    version = "5.99.1"          
    access_key = "AKIAXC3FBB2OJJC3DUIP"
    secret_key = "SECRET_KEY"
    region     = "us-east-2"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
    version = "4.32.0"
    features {}
}