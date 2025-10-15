#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root para obter todas as informações."
  exit 1
fi

echo "==================== SERVER PERFORMANCE STATS ===================="

# Total de uso da CPU
echo -e "\nTotal de uso da CPU:"
top -bn1 | grep "Cpu(s)" | awk '{print "Uso total: " 100 - $8 "%"}'

# Uso de memória
echo -e "\nUso de memória:"
free -m | awk 'NR==2{printf "Usado: %sMB / Total: %sMB (%.2f%%)\n", $3, $2, $3*100/$2 }'

# Uso de disco
echo -e "\nUso de disco:"
df -h --total | grep 'total' | awk '{print "Usado: " $3 " / Total: " $2 " (" $5 " usados)"}'

# Top 5 processos por uso de CPU
echo -e "\nTop 5 processos por uso de CPU:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 processos por uso de memória
echo -e "\nTop 5 processos por uso de memória:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# Informações adicionais (stretch goals)
echo -e "\nInformações adicionais:"

# Versão do sistema operacional
echo -e "\nVersão do sistema operacional:"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2

# Tempo de atividade
echo -e "\nTempo de atividade:"
uptime -p

# Carga média
echo -e "\nCarga média:"
uptime | awk -F'load average:' '{ print $2 }'

# Usuários logados
echo -e "\nUsuários logados:"
who | wc -l

# Tentativas de login falhadas
echo -e "\nTentativas de login falhadas:"
journalctl _COMM=sshd | grep "Failed password" | wc -l

echo -e "\n==============================================================="
