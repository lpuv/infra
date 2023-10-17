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

data "bitwarden_item_secure_note" "libreddit_password" {
  id = "e5cdb755-0bed-4b03-9a46-b06201719686"
}

data "bitwarden_item_secure_note" "whoogle_password" {
  id = "2bf390f3-4675-4fb9-a91b-b066010d1890"
}


data "bitwarden_item_secure_note" "mainframe_password" {
  id = "225290f3-ecf3-4603-957e-b07d0110ed70"
}

data "bitwarden_item_secure_note" "freshrss_password" {
  id = "e40abf83-f208-40a8-b024-b06200105e40"
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

resource "proxmox_lxc" "libreddit" {
  target_node  = "condor"
  hostname = "libreddit"
  ostemplate = "iso:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"
  unprivileged = true
  ostype = "debian"
  password = data.bitwarden_item_secure_note.libreddit_password.notes

  start = true

  cores = 2
  memory = 1024
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
    storage = "/local-zfs/data"
    volume = "/local-zfs/data"
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


resource "proxmox_lxc" "whoogle" {
  target_node  = "condor"
  hostname = "whoogle"
  ostemplate = "iso:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"
  unprivileged = true
  ostype = "debian"
  password = data.bitwarden_item_secure_note.whoogle_password.notes

  start = true

  cores = 1
  memory = 512
  swap = 1024

  ssh_public_keys = <<-EOF
  ${var.ssh_key}
  EOF

  rootfs {
    storage = "fast-zfs"
    size = "10G"
  }

  mountpoint {
    key = "0"
    slot = 0
    storage = "/local-zfs/data"
    volume = "/local-zfs/data"
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

resource "proxmox_lxc" "mainframe" {
  target_node  = "condor"
  hostname = "mainframe"
  ostemplate = "iso:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"
  unprivileged = true
  ostype = "debian"
  password = data.bitwarden_item_secure_note.mainframe_password.notes

  start = true

  cores = 1
  memory = 512
  swap = 1024

  ssh_public_keys = <<-EOF
  ${var.ssh_key}
  EOF

  rootfs {
    storage = "fast-zfs"
    size = "10G"
  }

  mountpoint {
    key = "0"
    slot = 0
    storage = "/local-zfs/data"
    volume = "/local-zfs/data"
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

resource "proxmox_lxc" "freshrss" {
  target_node  = "condor"
  hostname = "freshrss"
  ostemplate = "iso:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"
  unprivileged = true
  ostype = "debian"
  password = data.bitwarden_item_secure_note.freshrss_password.notes

  start = true

  cores = 1
  memory = 512
  swap = 1024

  ssh_public_keys = <<-EOF
  ${var.ssh_key}
  EOF

  rootfs {
    storage = "fast-zfs"
    size = "10G"
  }

  mountpoint {
    key = "0"
    slot = 0
    storage = "/local-zfs/data"
    volume = "/local-zfs/data"
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
