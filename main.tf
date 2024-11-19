# Define the provider block for Azure
provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = "test76gkhgk"   # Name of the Resource Group
  location = "East US"                  # Azure region (location) for the Resource Group
}

# Optional: Output the Resource Group name
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

