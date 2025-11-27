function showMessage() {
    const messages = [
        "Hello from JavaScript!",
        "Docker is awesome!",
        "Static apps rock!",
        "Welcome to containerization!"
    ];
    
    const randomMessage = messages[Math.floor(Math.random() * messages.length)];
    document.getElementById('message').textContent = randomMessage;
}