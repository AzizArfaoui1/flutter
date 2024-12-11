const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const Dog = require('./models/Dog');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

// Serve static files from the 'uploads' folder
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/adopet', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.log('Error connecting to MongoDB: ', err));

// Ensure uploads directory exists
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir);
}

// Multer storage configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage });

// Routes
app.get('/dogs', async (req, res) => {
  const dogs = await Dog.find();
  res.json(dogs);
});

app.post('/dogs', async (req, res) => {
  try {
    console.log('Request Body:', req.body);

    // Use the imageUrl directly from the request body
    const { name, age, gender, color, weight, distance, description, ownerName, ownerBio, imageUrl } = req.body;

    // Create the dog object with the imageUrl directly from the body
    const dogData = {
      name,
      age,
      gender,
      color,
      weight,
      distance,
      description,
      imageUrl,  // Directly use the image URL from the body
      owner: {
        name: ownerName,
        bio: ownerBio,
      },
    };

    console.log('Dog Data:', dogData);

    const dog = new Dog(dogData);
    await dog.save();
    res.status(201).send(dog);
  } catch (error) {
    console.error('Error:', error.message);
    res.status(500).send({ error: error.message });
  }
});


app.put('/dogs/:id', async (req, res) => {
  const dog = await Dog.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(dog);
});

app.delete('/dogs/:id', async (req, res) => {
  await Dog.findByIdAndDelete(req.params.id);
  res.status(204).send();
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
