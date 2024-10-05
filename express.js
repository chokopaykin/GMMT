const express = require("express");
const app = express();
app.use(express.json());

const users = [];

app.get('/usersList', (request, response) => {
    return response.sendJson(users);
});

app.post('/userUpdate', (request, response) => {
    if (!request.body.name || !request.body.server)
        return response.sendStatus(400);
    if (request.body.quit) {
        const userIndex = users.findIndex((u) => u.name == request.body.name && u.server == request.body.server)
        if (users[userIndex])
            users.splice(userIndex, 1)
        return response.sendStatus(200);
    }
    users.push({
        name: request.body.name,
        server: request.body.server
    });
    return response.sendStatus(200);
});

app.listen(3000);