source "virtualbox-iso" "ubuntu" {
  guest_os_type = "Ubuntu_64"
  iso_url = "http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.5-server-amd64.iso"
  iso_checksum = "sha256:8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
  ssh_username = "packer"
  ssh_password = "packer"
  ssh_port= 22
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  http_directory = "http"
  guest_additions_mode = "disable"
  boot_command = [
        "<esc><wait>",
        "<esc><wait>",
        "<enter><wait>",
        "/install/vmlinuz<wait>",
        " auto<wait>",
        " console-setup/ask_detect=false<wait>",
        " console-setup/layoutcode=us<wait>",
        " console-setup/modelcode=pc105<wait>",
        " debconf/frontend=noninteractive<wait>",
        " debian-installer=en_US<wait>",
        " fb=false<wait>",
        " initrd=/install/initrd.gz<wait>",
        " kbd-chooser/method=us<wait>",
        " keyboard-configuration/layout=USA<wait>",
        " keyboard-configuration/variant=USA<wait>",
        " locale=en_US<wait>",
        " netcfg/get_domain=vm<wait>",
        " netcfg/get_hostname=packer<wait>",
        " grub-installer/bootdev=/dev/sda<wait>",
        " noapic<wait>",
        " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
        " -- <wait>",
        "<enter><wait>"
      ]
}

build {
    sources = ["source.virtualbox-iso.ubuntu"]

    provisioner "file"{
        sources = [".ssh/id_rsa", ".ssh/id_rsa.pub"]
        destination = "/tmp/"
    }

    provisioner "shell"{
        script = "./packer_installer.sh"
        execute_command = "echo 'packer' | sudo -S -E sh -c '{{ .Vars }} {{ .Path }}'"
    }

    post-processor "vagrant" {
        keep_input_artifact = false
        provider_override = "virtualbox"
    }
}