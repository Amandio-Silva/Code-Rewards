# Hours Played Rewards Panel - FiveM (Standalone)
## 📌 Description
This script adds a reward system based on playtime on the FiveM server. Players can accumulate hours and redeem rewards as they reach predefined milestones.

## ⚙️ Features
- Stores player playtime.
- Configurable reward system.
- Support for different types of rewards (money, weapons, items).
- NUI interface for progress visualization and reward redemption.
- Fully standalone (no framework dependencies).

## 📂 Project Structure
```
/rewards
│── config.lua        # Reward configuration
│── server/          
│   ├── server.lua      # Server logic and database
│── client/          
│   ├── client.lua      # NUI communication and player events
│── ui/               # NUI graphical interface
│   ├── index.html    # Main interface page
│   ├── css/         
│   │   ├── style.css  # Interface styling
│   ├── js/          
│   │   ├── script.js  # Interface interaction
```

## 🛠️ Installation
1. **Download and extract the files** into your FiveM server's `resources/rewards` folder.
2. **Configure the `server.cfg`** by adding the line:
   ```cfg
   ensure rewards
   ```
3. **Edit the `config.lua`** to customize the rewards.
4. **Restart the server and you're done!**

## 🎮 Commands
- `/rewards` → Opens the rewards panel.

## 🔧 Dependencies
- `oxmysql` database (can be adapted for other SQL systems).

## 📝 Configuration (`config.lua`)
Example reward configuration:
```lua
Config.Rewards = {
    {
        name = "100 Coins",
        description = "Earn 100 coins for playing",
        hours = 1,
        type = "money",
        amount = 100
    },
    {
        name = "Weapon Package",
        description = "Unlock special weapons",
        hours = 3,
        type = "weapon",
        items = {"WEAPON_PISTOL", "WEAPON_SMG"}
    }
}
```

## 📞 Support
If you have questions or need support, please get in touch!

---
✍️ **Created by Amandio-Silva**
