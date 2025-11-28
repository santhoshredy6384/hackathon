@echo off
echo 📜 Running Ansible Playbook...

REM ========================================
REM Ansible Execution (via WSL)
REM ========================================
echo 🐧 Executing hackthon.yml inside WSL...
wsl ansible-playbook hackthon.yml

echo ✅ Ansible Playbook Execution Completed!
