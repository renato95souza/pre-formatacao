## 🚀 Pré‑Formatação Windows — Script PowerShell (Backup)

Este utilitário de **pré‑formatação** foi desenvolvido para garantir que configurações críticas e arquivos que o OneDrive geralmente ignora sejam salvos com segurança antes de uma formatação. Ele compacta pastas de aplicativos específicos e armazena os backups diretamente na sua pasta do OneDrive.

> **Observação:** Este script **não** requer privilégios de Administrador, pois atua sobre as pastas do perfil do usuário.

---

### 📂 O que este script salva?

O script realiza o backup (compactação `.zip`) das seguintes pastas:
* **MobaXterm:** Sessões, chaves e configurações.
* **DBeaver:** Bancos de dados salvos, scripts e conexões.
* **Notepad++:** Configurações completas, plugins e histórico de backups.
* **.oci:** Configurações e chaves da Oracle Cloud Infrastructure.

---

### 📥 Como Executar

Execute o comando abaixo no PowerShell para iniciar o script de backup:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& ([ScriptBlock]::Create((irm 'https://raw.githubusercontent.com/renato95souza/pre-formatacao/main/pre-install.ps1')))"
