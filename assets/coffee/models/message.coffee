mongo = require 'mongoose'
mongo.connect 'mongodb://localhost/cmapp'
  
Schema = mongo.Schema
  
Message = mongo.model 'messages', new Schema
  text: String
  location: [Number, Number]
  created_at: {type: Date, default: Date.now}
  updated_at: {type: Date, default: Date.now}
 
module.exports = Message