terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.6.1"
    }
  }
}

provider "proxmox" {
  # References our vars.tf file to plug in the api_url 
  pm_api_url = var.api_url
  # References our secrets.tfvars file to plug in our token_id
  #pm_api_token_id = var.token_id 
  # References our secrets.tfvars to plug in our token_secret 
  #pm_api_token_secret = var.token_secret
  pm_user = var.user
  pm_password = var.password
  # Default to `true` unless you have TLS working within your pve setup 
  pm_tls_insecure = true
  pm_debug = true
}

provider "bitwarden" {
  client_id = var.bitwarden_id
  client_secret = var.bitwarden_secret
  email = var.email
  master_password = var.master_password
}

data "bitwarden_item_secure_note" "media_password" {
  id = "158f7bb5-196a-4bf9-8c24-b06200105e40"
}

resource "proxmox_lxc" "media" {
  target_node  = "condor"
  hostname = "media"
  ostemplate = "iso:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"
  unprivileged = true
  ostype = "debian"
  password = data.bitwarden_item_secure_note.media_password.notes

  start = true

  cores = 4
  memory = 6144
  swap = 2048

  ssh_public_keys = <<-EOF
  ${var.ssh_key}
  EOF

  rootfs {
    storage = "fast-zfs"
    size = "40G"
  }

  mountpoint {
    key = "0"
    slot = 0
    storage = "/local-zfs/media"
    volume = "/local-zfs/media"
    mp = "/data"
    size = "600G"
  }

  features {
    fuse    = true
    nesting = true
  }

  network {
    name = "eth0"
    bridge = "vmbr1"
    ip = "dhcp"
    ip6 = "manual"
  }

}
