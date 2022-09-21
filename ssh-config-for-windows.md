## Change the SSH port on Windows 10/11

1. Change port in config file %programdata%\ssh\sshd_config
```
Port 2204
```
2. Open PowerShell with Administrator
3. Execute following command (Using a different DisplayName to distinguish default rule):
```
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Custom Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 2204
```
4. Restart 'SSH server' windows service
5. (optional but recommended) Disable firewall rule for default 22 port

## Setting to use git-bash as default shell via OpenSSH
```
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\Git\bin\bash.exe" -PropertyType String -Force
```
