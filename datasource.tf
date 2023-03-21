

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    wg_server_private_key = var.wg_server_private_key
    wg_server_net         = var.wg_server_net
    wg_server_port        = var.wg_server_port
    lan_net               = var.lan_net
    peers                 = join("\n", data.template_file.wg_client_data_json.*.rendered)
    wg_server_interface   = var.wg_server_interface
  }
}

data "template_file" "wg_client_data_json" {
  template = file("${path.module}/templates/wireguard-peer-data.tpl")
  count    = length(var.wg_client_public_keys)

  vars = {
    client_pub_key       = element(values(var.wg_client_public_keys[count.index]), 0)
    client_ip            = element(keys(var.wg_client_public_keys[count.index]), 0)
    persistent_keepalive = var.wg_persistent_keepalive
    wg_server_net        = var.wg_server_net
    lan_net              = var.lan_net
  }
}

# data "cloudinit_config" "cloudinit-example" {
#   gzip          = false
#   base64_encode = false

#   part {
#     filename     = "init.cfg"
#     content_type = "text/cloud-config"
#     content = templatefile("scripts/init.cfg", {
#       REGION = var.AWS_REGION
#     })
#   }

#   part {
#     content_type = "text/x-shellscript"
#     content = templatefile("scripts/volumes.sh", {
#       DEVICE = var.INSTANCE_DEVICE_NAME
#     })
#   }
# }
