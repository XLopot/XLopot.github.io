document.addEventListener('DOMContentLoaded', function() {
    const scrollingText = document.getElementById('scrollingText');
    const speedValue = document.getElementById('speedValue');
    const statusValue = document.getElementById('statusValue');
    const timeValue = document.getElementById('timeValue');
    const timestamp = document.getElementById('timestamp');
    
    const speedUpBtn = document.getElementById('speedUpBtn');
    const speedDownBtn = document.getElementById('speedDownBtn');
    const restartBtn = document.getElementById('restartBtn');
    const pauseBtn = document.getElementById('pauseBtn');
    
    // Текст для анимации
    const textLines = [
        { text: "", className: "text-line system" },
        { text: "", assName: "text-line system" },
        { text: "", lassName: "text-line system" },
        { text: "", className: "text-line" },
        { text: "ВЫ БЫЛИ ВАЛИДНУТЫ", className: "text-line highlight" },
        { text: "", className: "text-line" },
        { text: "НАД ВАМИ РАБОТАЛИ:", className: "text-line system" },
        { text: "@fuckdarkneterov", className: "text-line user indent" },
        { text: "@qwesmilw", className: "text-line user indent" },
        { text: "@Mur1ka_official", className: "text-line user indent" },
        { text: "...ЕЩЕ 206 ЧЕЛОВЕК", className: "text-line warning indent" },
        { text: "", className: "text-line" },
        { text: "КЛАНЫ РАБОТАЮЩИЕ НАД ВАМИ:", className: "text-line system" },
        { text: "2,400 ЧЕЛОВЕК", className: "text-line warning" },
        { text: "", className: "text-line" },
        { text: "ВЫ БЫЛИ ВАЛИДНУТЫ В:", className: "text-line system" },
        { text: "18.12.25", className: "text-line highlight" },
        { text: "", className: "text-line" },
        { text: "ОШИБКА ВАЛИДАЦИИ:", className: "text-line system" },
        { text: "ЛИВ С КМ", className: "text-line error" },
        { text: "", className: "text-line" },
        { text: "ИТОГ:", className: "text-line system" },
        { text: "ВЫ ПОТЕРЯЛИ ВСЁ:", className: "text-line error" },
        { text: "• ОТ НАСТРОЕНИЯ ИЗ-ЗА КМ", className: "text-line error indent" },
        { text: "• ДО ИНФЫ 2021 ГОДА", className: "text-line error indent" },
        { text: "• СЛЕЖКА ЗА ВК И НОМЕРОМ", className: "text-line error indent" }
    ];
    
    // Переменные состояния
    let currentSpeed = 1;
    let isPaused = false;
    let startTime = new Date();
    let animationId = null;
    
    // Инициализация текста
    function initText() {
        scrollingText.innerHTML = '';
        
        textLines.forEach((line, index) => {
            const lineElement = document.createElement('div');
            lineElement.className = line.className;
            lineElement.textContent = line.text;
            lineElement.style.animationDelay = `${index * 0.2}s`;
            scrollingText.appendChild(lineElement);
        });
    }
    
    // Обновление времени
    function updateTime() {
        const now = new Date();
        const elapsed = Math.floor((now - startTime) / 1000);
        const minutes = Math.floor(elapsed / 60).toString().padStart(2, '0');
        const seconds = (elapsed % 60).toString().padStart(2, '0');
        timeValue.textContent = `${minutes}:${seconds}`;
        
        // Обновление timestamp в футере
        const currentTime = now.toLocaleTimeString('ru-RU', { 
            hour: '2-digit', 
            minute: '2-digit',
            second: '2-digit'
        });
        timestamp.textContent = currentTime;
    }
    
    // Управление скоростью анимации
    function updateAnimationSpeed() {
        const animationDuration = 60 / currentSpeed;
        scrollingText.style.animationDuration = `${animationDuration}s`;
        speedValue.textContent = `${currentSpeed}x`;
        
        if (isPaused) {
            scrollingText.style.animationPlayState = 'paused';
            statusValue.textContent = 'На паузе';
            statusValue.style.color = '#ff9900';
        } else {
            scrollingText.style.animationPlayState = 'running';
            statusValue.textContent = 'Выполняется...';
            statusValue.style.color = '#00cc00';
        }
    }
    
    // Перезапуск анимации
    function restartAnimation() {
        scrollingText.style.animation = 'none';
        void scrollingText.offsetWidth; // Trigger reflow
        scrollingText.style.animation = null;
        updateAnimationSpeed();
        startTime = new Date();
        isPaused = false;
        pauseBtn.innerHTML = '<i class="fas fa-pause"></i><span>Пауза</span>';
    }
    
    // Инициализация
    function init() {
        initText();
        updateAnimationSpeed();
        
        // Обновление времени каждую секунду
        setInterval(updateTime, 1000);
        
        // Обработчики кнопок
        speedUpBtn.addEventListener('click', function() {
            if (currentSpeed < 3) {
                currentSpeed += 0.5;
                updateAnimationSpeed();
            }
        });
        
        speedDownBtn.addEventListener('click', function() {
            if (currentSpeed > 0.5) {
                currentSpeed -= 0.5;
                updateAnimationSpeed();
            }
        });
        
        restartBtn.addEventListener('click', restartAnimation);
        
        pauseBtn.addEventListener('click', function() {
            isPaused = !isPaused;
            
            if (isPaused) {
                pauseBtn.innerHTML = '<i class="fas fa-play"></i><span>Продолжить</span>';
                statusValue.textContent = 'На паузе';
                statusValue.style.color = '#ff9900';
            } else {
                pauseBtn.innerHTML = '<i class="fas fa-pause"></i><span>Пауза</span>';
                statusValue.textContent = 'Выполняется...';
                statusValue.style.color = '#00cc00';
            }
            
            updateAnimationSpeed();
        });
        
        // Когда анимация завершится
        scrollingText.addEventListener('animationend', function() {
            statusValue.textContent = 'Завершено';
            statusValue.style.color = '#ff3333';
        });
        
        // Добавляем эффект печатания для первой строки
        const firstLines = document.querySelectorAll('.text-line');
        firstLines.forEach((line, index) => {
            line.style.opacity = '0';
            setTimeout(() => {
                line.style.transition = 'opacity 0.5s ease';
                line.style.opacity = '1';
            }, index * 100);
        });
    }
    
    // Запуск
    init();
    
    // Добавляем случайные эффекты матрицы на фон
    function createMatrixEffect() {
        const chars = "01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン";
        
        setInterval(() => {
            const matrixChar = document.createElement('div');
            matrixChar.textContent = chars[Math.floor(Math.random() * chars.length)];
            matrixChar.style.position = 'fixed';
            matrixChar.style.left = `${Math.random() * 100}vw`;
            matrixChar.style.top = '-20px';
            matrixChar.style.color = `rgba(0, ${Math.floor(Math.random() * 255)}, 0, ${Math.random() * 0.5 + 0.3})`;
            matrixChar.style.fontSize = `${Math.random() * 20 + 10}px`;
            matrixChar.style.fontFamily = 'monospace';
            matrixChar.style.pointerEvents = 'none';
            matrixChar.style.zIndex = '-1';
            matrixChar.style.textShadow = '0 0 10px currentColor';
            
            document.body.appendChild(matrixChar);
            
            // Анимация падения
            const duration = Math.random() * 3000 + 2000;
            matrixChar.animate([
                { transform: 'translateY(0)', opacity: 1 },
                { transform: `translateY(${window.innerHeight + 100}px)`, opacity: 0 }
            ], {
                duration: duration,
                easing: 'linear'
            });
            
            // Удаляем элемент после анимации
            setTimeout(() => {
                matrixChar.remove();
            }, duration);
        }, 100);
    }
    
    // Запускаем эффект матрицы
    createMatrixEffect();
});