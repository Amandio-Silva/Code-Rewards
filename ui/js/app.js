const rewards = [
    {
        id: 1,
        name: "100 Moedas",
        description: "Resgate moedas para usar na loja premium do servidor",
        hours: 15
    },
    {
        id: 2,
        name: "1000 Moedas",
        description: "Resgate moedas para usar na loja premium do servidor",
        hours: 20
    },
    {
        id: 3,
        name: "Diamantes",
        description: "Resgate 100 diamantes para usar em nossa loja premium",
        hours: 30
    },
    {
        id: 4,
        name: "Pacote de Armas",
        description: "Resgate 2 Pistolas Five Seven e 1 Rifle AK-47",
        hours: 35
    },
    {
        id: 5,
        name: "Skin Especial",
        description: "Resgate uma skin especial para seu personagem",
        hours: 40
    },
    {
        id: 6,
        name: "Skin Especial",
        description: "Resgate uma skin especial para seu personagem",
        hours: 40
    },
    {
        id: 7,
        name: "Skin Especial",
        description: "Resgate uma skin especial para seu personagem",
        hours: 40
    },
    {
        id: 8,
        name: "Skin Especial",
        description: "Resgate uma skin especial para seu personagem",
        hours: 40
    },
    {
        id: 9,
        name: "Skin Especial",
        description: "Resgate uma skin especial para seu personagem",
        hours: 40
    },
    {
        id: 10,
        name: "Skin Especial",
        description: "Resgate uma skin especial para seu personagem",
        hours: 40
    },
    {
        id: 11,
        name: "Skin Especial",
        description: "Resgate uma skin especial para seu personagem",
        hours: 40
    },
    {
        id: 12,
        name: "Skin Especial",
        description: "Resgate uma skin especial para seu personagem",
        hours: 40
    }
].sort((a, b) => a.hours - b.hours);

let currentIndex = 0;
let playerTime = { hours: 30, minutes: 0, seconds: 0 };
let redeemedItems = new Set();

const rewardScreen = document.querySelector('.reward-screen');
const rewardsGrid = document.getElementById('rewardsGrid');
const prevButton = document.getElementById('prevButton');
const nextButton = document.getElementById('nextButton');
const closeButton = document.getElementById('closeButton');
const hoursCounter = document.querySelector('.hours-counter');

function getIcon(rewardName) {
    const name = rewardName.toLowerCase();
    if (name.includes('moedas')) {
        return '<i class="fas fa-coins"></i>';
    } else if (name.includes('item raro')) {
        return '<i class="fas fa-gem"></i>';
    } else if (name.includes('skin')) {
        return '<i class="fas fa-tshirt"></i>';
    } else if (name.includes('armas')) {
        return '<i class="fas fa-gun"></i>';
    } else {
        return '<i class="fas fa-gift"></i>';
    }
}

function formatTime(time) {
    return `${time.hours}h ${time.minutes}m ${time.seconds}s`;
}

function createRewardCard(reward) {
    const isLocked = playerTime.hours < reward.hours;
    const isRedeemed = redeemedItems.has(reward.id);

    const card = document.createElement('div');
    card.className = `reward-card ${isLocked ? 'locked' : ''} ${isRedeemed ? 'redeemed' : ''}`;

    card.innerHTML = `
        <div class="hours-badge">
            <i class="fas fa-clock"></i>
            ${reward.hours}h
        </div>
        <div class="reward-icon">
            ${getIcon(reward.name)}
        </div>
        <div class="reward-info">
            <h3>${reward.name}</h3>
            <p>${reward.description}</p>
        </div>
        ${isLocked ? `
            <div class="lock-overlay">
                <i class="fas fa-lock"></i>
                <span class="remaining-time">Faltam ${reward.hours - playerTime.hours}h</span>
            </div>
        ` : ''}
        ${isRedeemed ? `
            <div class="redeemed-badge">
                <i class="fas fa-check"></i>
                Resgatado
            </div>
        ` : ''}`;

    if (!isLocked && !isRedeemed) {
        card.addEventListener('click', () => handleRewardRedeem(reward));
    }

    return card;
}

function updateRewardsGrid() {
    rewardsGrid.style.transform = `translateX(-${currentIndex * (280 + 24)}px)`;
    prevButton.disabled = currentIndex === 0;
    nextButton.disabled = currentIndex >= rewards.length - 4;
    
    const progressBar = document.querySelector('.progress-bar-fill');
    const totalSlides = rewards.length - 4;
    const progress = (currentIndex / totalSlides) * 100;
    progressBar.style.width = `${progress}%`;
}

function renderRewards() {
    rewardsGrid.innerHTML = '';
    rewards.forEach(reward => {
        rewardsGrid.appendChild(createRewardCard(reward));
    });
    updateRewardsGrid();
}

function handlePrevClick() {
    currentIndex = Math.max(0, currentIndex - 1);
    updateRewardsGrid();
}

function handleNextClick() {
    currentIndex = Math.min(currentIndex + 1, rewards.length - 4);
    updateRewardsGrid();
}

function handleRewardRedeem(reward) {
    if (!redeemedItems.has(reward.id)) {
        redeemedItems.add(reward.id);
        fetch('https://rewards/redeemReward', {
            method: 'POST',
            body: JSON.stringify({ reward })
        });
        renderRewards();
    }
}

function handleClose() {
    fetch('https://rewards/closeUI', {
        method: 'POST'
    });
}

window.addEventListener('message', (event) => {
    const data = event.data;

    switch (data.type) {
        case 'OPEN_UI':
            rewardScreen.classList.add('visible');
            if (data.playerTime) {
                playerTime = data.playerTime;
                hoursCounter.textContent = formatTime(playerTime);
                renderRewards();
            }
            break;
        case 'CLOSE_UI':
            rewardScreen.classList.remove('visible');
            break;
        case 'UPDATE_TIME':
            if (data.playerTime) {
                playerTime = data.playerTime;
                hoursCounter.textContent = formatTime(playerTime);
                renderRewards();
            }
            break;
    }
});

prevButton.addEventListener('click', handlePrevClick);
nextButton.addEventListener('click', handleNextClick);
if (closeButton) {
    closeButton.addEventListener('click', handleClose);
}

rewardScreen.addEventListener('transitionend', function(e) {
    if (e.propertyName === 'opacity' && rewardScreen.classList.contains('visible')) {
        renderRewards();
    }
});

if (rewardScreen.classList.contains('visible')) {
    renderRewards();
}