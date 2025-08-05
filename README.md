# Pipe in your variables in fly.toml first

## Please just do that then anything else later

 Then create a volume
`fly volumes create <volume_name> [--size <size>] [-a <your_app>]`

Then pipe your secrets
`fly secrets set MYSQL_PASSWORD=<your_user_pwds> MYSQL_ROOT_PASSWORD=<your_root_pwds> TS_AUTHKEY=<your_tailscale_auth_key> [-a <your_app>]`

Then go ham on it
`fly launch [-a <your_app>]`