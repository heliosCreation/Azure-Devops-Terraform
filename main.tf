provider "azurerm"{
    version = "2.5.0"
    features {}
}

terraform {
    backend "azurerm"{
        resource_group_name         = "TFMain_BlobStorage_RG"
        storage_account_name        = "terraformsorageaccount"
        container_name              = "tfstate"
        key                         = "terraform.tfstate"       
    }
}

variable "IMAGEBUILD" {
  type        = string
  description = "The latest image build"
}


resource "azurerm_resource_group" "tf_test"{
    name = "tfMain_RG"
    location = "West Europe"
}

resource "azurerm_container_group" "tfcg_test"{
    name                = "weatherapi"
    location            = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type     = "public"
    dns_name_label      = "heliosCreaWa"
    os_type             = "Linux"

    container{
        name        = "weatherapi"
        image       = "quentincouissinier/weatherapiwithterraform:${var.IMAGEBUILD}"
        cpu         = "1"
        memory      = "1"

        ports{
            port        = 80
            protocol    = "TCP"
        }
    }
}