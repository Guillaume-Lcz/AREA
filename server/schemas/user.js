/* eslint-disable no-useless-catch */
import mongoose from 'mongoose';
import bcrypt from 'bcrypt';

const Schema = mongoose.Schema;

const Service = new Schema({
  isConnected: {
    type: Boolean,
    default: false,
  },
  accessToken: {
    type: String,
    default: '',
  },
  refreshToken: {
    type: String,
    default: '',
  },
  data: {
    type: Map,
    of: Object,
    default: [],
  },
});

const User = new Schema({
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    default: '',
  },
  name: {
    type: String,
    default: '',
  },
  googleId: {
    type: Number,
    require: true,
    default: 0,
  },
  isGoogleAuth: {
    type: Boolean,
    required: true,
    default: false,
  },
  servicesData: {
    type: Map,
    of: Service,
    default: [],
  },
});

User.pre('save', async function (next) {
  try {
    this.password = await bcrypt.hash(this.password, 10);
    return next();
  } catch (error) {
    return next(error);
  }
});

User.methods.comparePassword = async function (candidatePassword) {
  try {
    if (!candidatePassword) {
      return false;
    }
    return await bcrypt.compare(candidatePassword, this.password);
  } catch (error) {
    throw error;
  }
};

const ModelUser = mongoose.model('users', User);

export { ModelUser };
