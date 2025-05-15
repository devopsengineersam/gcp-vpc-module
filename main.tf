module "network" {
  source = "./module/networking"
  network_name = "dspm-dig-vpc"

  subnet_configurations = {
    "us-west1"    = { cidr_block = "10.128.2.0/24"  }
    "us-west2"    = { cidr_block = "10.128.3.0/24"  }
    "us-west3"    = { cidr_block = "10.129.4.0/24"  }
    "us-west4"    = { cidr_block = "10.128.5.0/24"  }
    "us-south1"   = { cidr_block = "10.129.6.0/24"  }
    "us-east1"    = { cidr_block = "10.128.7.0/24"  }
    "us-east4"    = { cidr_block = "10.129.8.0/24"  }
    "us-east5"    = { cidr_block = "10.128.9.0/24"  }
    "us-central1" = { cidr_block = "10.129.1.0/24"  }
  }

  enable_private_service_access = true
  nat_logging_enabled           = false
}