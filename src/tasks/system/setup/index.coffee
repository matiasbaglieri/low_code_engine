Promise      = require 'bluebird'
mongo        = require '../../../dbs/mongoose'
config       = require '../../../config/config'
log          = require('../../../tools/log').create 'setup_task'
utils        = require '../../../tools/utils'
task_tools   = require '../../tools'
sv_countries = require './countries'
sv_net       = require './networks'
sv_acl       = require './acl'
sv_subscript = require './subscription'
fs           = require 'fs'

@execute_db_job = (worker_id, data) ->
  log.d("----------------- setup: execute_db_job #{worker_id} #{JSON.stringify(data)} -----------------")
  Promise.try ->
    task_tools.qtasks.pre_execute worker_id, data
  .then (worker) ->
    log.d("----------------- setup: building countries-----------------")
    sv_countries.countries() 
  .then (dep) ->
    execute_subtasks(worker_id, data)
  .then (dep) ->
    log.d("----------------- setup:finished-----------------")
  .catch (err) ->
    if err.message in ["UPLOADING_COUNTRIES",'NOT_CONFIG_FOUND','NOT_WORKER_FOUND','QTASK_NO_DEPURATION_NEEDED']
      log.d "contempled catchs in setup:database #{err.message}"
    else
      log.e "#{err.stack}"

@execute_subtasks = execute_subtasks = (worker_id, data) ->
  Promise.try ->
    mongo.countries.countDocuments()
  .then (country_m) ->
    if country_m < 240
      throw new Error('UPLOADING_COUNTRIES')
    log.d("----------------- setup: building currencies-----------------")
    sv_countries.currencies()
  .then (dep) ->
    log.d("----------------- setup: building users-----------------")
    sv_acl.users()
  .then (dep) ->
    log.d("----------------- setup: building categories-----------------")
    sv_net.categories()
  .then (dep) ->
    log.d("----------------- setup: building networks-----------------")
    sv_net.networks()
  .then (dep) ->
    log.d("----------------- setup: building communities-----------------")
    sv_net.communities()
  .then (dep) ->
    log.d("----------------- setup: building environments-----------------")
    sv_net.environments()
  .then (dep) ->
    log.d("----------------- setup: building roles-----------------")
    sv_acl.roles()
  .then (dep) ->
    log.d("----------------- setup: building user_role-----------------")
    sv_acl.user_role()
  .then (dep) ->
    log.d("----------------- setup: building requestmaps-----------------")
    sv_acl.requestmaps()
  .then (dep) ->
    log.d("----------------- setup: building requestmap_role-----------------")
    sv_acl.requestmap_role()
  .then (dep) ->
    log.d("----------------- setup: building subscription-----------------")
    sv_subscript.subscription()
  .then (dep) ->
    log.d("----------------- setup: building spells-----------------")
    sv_subscript.spells()
  .then (dep) ->
    log.d("----------------- setup: post_execute-----------------")
    task_tools.qtasks.post_execute worker_id, data
  .then (lg) ->
    log.d lg

