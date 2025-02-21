CREATE TABLE IF NOT EXISTS player_playtime (
    license VARCHAR(50) PRIMARY KEY,
    hours INT DEFAULT 0,
    minutes INT DEFAULT 0,
    seconds INT DEFAULT 0,
    total_seconds BIGINT DEFAULT 0,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS player_rewards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(255) NOT NULL,
    reward_name VARCHAR(255) NOT NULL,
    UNIQUE (license, reward_name)
);
