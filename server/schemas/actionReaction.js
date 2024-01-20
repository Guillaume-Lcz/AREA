import mongoose from 'mongoose';

const Action = new mongoose.Schema(
  {
    service: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      default: '',
    },
    data: {
      type: Object,
      required: true,
    },
    dataLocalServer: {
      type: Object,
      required: false,
      default: {},
    },
  },
  { minimize: false }
);

const Reaction = new mongoose.Schema(
  {
    service: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      default: '',
    },
    data: {
      type: Object,
      required: true,
    },
    dataLocalServer: {
      type: Object,
      required: false,
      default: {},
    },
  },
  { minimize: false }
);

const Area = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
  },
  action: {
    type: Action,
    required: true,
  },
  reaction: {
    type: [Reaction],
    default: [],
    required: true,
  },
});

const ModelArea = mongoose.model('area', Area);

export { ModelArea };
