mongoose      = require 'mongoose'
utils         = require '../../../tools/utils'

offer_product = mongoose.Schema

  offer:
    type: mongoose.Schema.ObjectId
    ref: 'offer'
    required: true
    
  clazz_obj:
    type: mongoose.Schema.ObjectId
    required: true

  clazz:
    type    : String
    enum    : ['SUBSCRIPTION','PRODUCTS', 'AUCTION']
    default : "SUBSCRIPTION"
    required: true

  type:
    type    : String
    enum    : ['SYSTEM','MERCHANT','COMMUNITY','ENVIRONMENT']
    default : "SYSTEM"
    required: true
  status:
    type    : String
    enum    : ['AVAILABLE','PENDING', 'INACTIVE', 'DISABLED','DELETED']
    default : "AVAILABLE"
    required: true
    

  json_data:
    type   : mongoose.Schema.Types.Mixed
    default: {}
 
  created_at    : Date
  updated_at    : Date
      

module.exports = mongoose.model "offer_product", (offer_product
).pre 'save', utils.update_timestamp
