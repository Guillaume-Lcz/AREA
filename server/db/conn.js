import mongoose from 'mongoose';

await mongoose.connect(process.env.ATLAS_URI, {
  serverApi: {
    version: '1',
    strict: true,
    deprecationErrors: true,
  },
});

const db = mongoose.connection;

db.on('error', (error) => {
  console.error('MongoDB connection error:', error);
  process.exit(1);
});

db.once('open', () => {
  console.log('Successfully connected to MongoDB Atlas');
});

export { db };
