const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// In-memory storage for messages per user
const User = {};
const Anotheruser = {};

// In-memory inventory storage per user
const Inventory = {
  User: [],
  Anotheruser: [],
};

// Helper function to validate user key
function isValidUser(user) {
  return user === 'User' || user === 'Anotheruser';
}

// POST /send - store a message for a user
app.post('/send', (req, res) => {
  const { sender, message } = req.body;
  if (!sender || !message) {
    return res.status(400).json({ error: 'Missing sender or message' });
  }
  if (!isValidUser(sender)) {
    return res.status(400).json({ error: 'Invalid sender name' });
  }
  // Store message in user's history
  const userHistory = sender === 'User' ? User : Anotheruser;
  if (!userHistory.history) {
    userHistory.history = [];
  }
  userHistory.history.push(message);

  res.json({ status: `Message stored for ${sender}` });
});

// GET /receive?user=User - get all messages for a given user
app.get('/receive', (req, res) => {
  const user = req.query.user;
  if (!isValidUser(user)) {
    return res.status(400).json({ error: 'Invalid or missing user parameter' });
  }
  const userHistory = user === 'User' ? User : Anotheruser;
  res.json({ messages: userHistory.history || [] });
});

// POST /inventory - add an item to inventory for a user
app.post('/inventory', (req, res) => {
  const { user, item } = req.body;
  if (!isValidUser(user)) {
    return res.status(400).json({ error: 'Invalid or missing user' });
  }
  if (!item) {
    return res.status(400).json({ error: 'Missing item' });
  }
  Inventory[user].push(item);
  res.json({ status: `Item added to ${user}'s inventory` });
});

// GET /inventory?user=User - get inventory items for a user in plain text, one per line
app.get('/inventory', (req, res) => {
  const user = req.query.user;
  if (!isValidUser(user)) {
    return res.status(400).json({ error: 'Invalid or missing user parameter' });
  }
  const items = Inventory[user];
  if (items.length === 0) {
    return res.send(`${user}'s inventory is empty.`);
  }
  res.send(items.join('\n'));
});

// DELETE /history?user=User - clear message history for the user
app.delete('/history', (req, res) => {
  const user = req.query.user;
  if (!isValidUser(user)) {
    return res.status(400).json({ error: 'Invalid or missing user parameter' });
  }
  const userHistory = user === 'User' ? User : Anotheruser;
  userHistory.history = [];
  res.json({ status: `Message history cleared for ${user}` });
});

// DELETE /inventory?user=User - clear inventory for the user
app.delete('/inventory', (req, res) => {
  const user = req.query.user;
  if (!isValidUser(user)) {
    return res.status(400).json({ error: 'Invalid or missing user parameter' });
  }
  Inventory[user] = [];
  res.json({ status: `Inventory cleared for ${user}` });
});

// Root endpoint to show basic info
app.get('/', (req, res) => {
  res.send('Roblox exploit message relay server running. Use /send, /receive, /inventory endpoints with user parameters.');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

