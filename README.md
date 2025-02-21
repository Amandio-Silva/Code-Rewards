# Painel de Recompensas por Horas Jogadas - FiveM (Standalone)

## 📌 Descrição
Este script adiciona um sistema de recompensas baseado no tempo jogado no servidor FiveM. Os jogadores podem acumular horas e resgatar recompensas conforme atingem metas pré-definidas.

## ⚙️ Funcionalidades
- Armazena o tempo de jogo dos jogadores.
- Sistema de recompensas configurável.
- Suporte para diferentes tipos de recompensas (dinheiro, armas, itens).
- Interface NUI para visualização do progresso e resgate de recompensas.
- Totalmente standalone (sem dependência de frameworks).

## 📂 Estrutura do Projeto
```
/rewards
│── config.lua        # Configuração de recompensas
│── server/          
│   ├── server.lua      # Lógica do servidor e banco de dados
│── client/          
│   ├── cleient.lua      # Comunicação com a NUI e eventos do jogador
│── ui/               # Interface gráfica NUI
│   ├── index.html    # Página principal da interface
│   ├── css/         
│   │   ├── style.css  # Estilização da interface
│   ├── js/          
│   │   ├── script.js  # Interação com a interface
```

## 🛠️ Instalação
1. **Baixe e extraia os arquivos** na pasta `resources/rewards` do seu servidor FiveM.
2. **Configure o `server.cfg`** adicionando a linha:
   ```cfg
   ensure rewards
   ```
3. **Edite o `config.lua`** para personalizar as recompensas.
4. **Reinicie o servidor e pronto!**

## 🎮 Comandos
- `/rewards` → Abre o painel de recompensas.

## 🔧 Dependências
- Banco de dados `oxmysql` (pode ser adaptado para outro sistema SQL).

## 📝 Configuração (`config.lua`)
Exemplo de configuração de recompensas:
```lua
Config.Rewards = {
    {
        name = "100 Moedas",
        description = "Ganhe 100 moedas por jogar",
        hours = 1,
        type = "money",
        amount = 100
    },
    {
        name = "Pacote de Armas",
        description = "Desbloqueie armas especiais",
        hours = 3,
        type = "weapon",
        items = {"WEAPON_PISTOL", "WEAPON_SMG"}
    }
}
```

## 📞 Suporte
Caso tenha dúvidas ou precise de suporte, entre em contato!

---
✍️ **Criado por Code LAB**
