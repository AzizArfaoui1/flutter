const mongoose = require('mongoose');

const DogSchema = new mongoose.Schema({
  id:Number,
  name: String,
  age: Number,
  gender: String,
  color: String,
  weight: Number,
  distance: String,
  imageUrl: String,
  description: String,
  owner: {
    name: String,
    bio: String,
  }
});

module.exports = mongoose.model('Dog', DogSchema);
