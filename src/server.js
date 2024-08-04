const express = require('express');
const path = require('path');
const app = express();
app.use(express.static(path.join(__dirname, 'my-app/build')));

app.get('/', function(req, res) {
  res.sendFile(path.join(__dirname, 'my-app/build', 'index.html'));
});

// Định nghĩa các route khác (nếu cần)

const port = process.env.PORT || 3001;
app.listen(port, function() {
  console.log(`Server đang chạy trên port ${port}`);
});
