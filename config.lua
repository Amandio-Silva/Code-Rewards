Config = {}

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
    },
    {
        name = "Kit VIP",
        description = "Itens exclusivos para jogadores dedicados",
        hours = 5,
        type = "items",
        items = {
            {name = "medkit", amount = 5},
            {name = "armor", amount = 1}
        }
    }
}

return Config