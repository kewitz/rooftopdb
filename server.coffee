###                                                                      
                                  _|_|    _|                          
_|  _|_|    _|_|      _|_|      _|      _|_|_|_|    _|_|    _|_|_|    
_|_|      _|    _|  _|    _|  _|_|_|_|    _|      _|    _|  _|    _|  
_|        _|    _|  _|    _|    _|        _|      _|    _|  _|    _|  
_|          _|_|      _|_|      _|          _|_|    _|_|    _|_|_|    
                                                            _|        
                                                            _|        
###

# Import de bibliotecas
express = require 'express'
sass = require 'sass'
fs = require 'fs'
path = require 'path'
util = require 'util'
exec = require('child_process').exec
jade = require 'jade'

# Constants
INC_DIR = './inc/'

# Import de arquivos locais
#User = require './lib/user.coffee'


server = express()
server.set 'views', path.join __dirname, 'views'
server.set 'view engine', 'jade'
server.use express.static path.join __dirname, 'public'

server.use "/css/:style", (req,res,next) -> 
  if fs.existsSync(INC_DIR+req.params.style+'.sass') && req.method == 'GET'
    exec 'sass inc/'+req.params.style+'.sass',(error, stdout, stderr) ->
      throw error if error
      res.send stdout
  else
    next()

server.get '/', (req,res) -> res.render 'index', {'username':'gunar'}

#server.post "/", User.create

###
server.get "/user/:id", (req,res) ->
  u = User.find(req.params.id)
  res.json(u)
###

server.use '*', (req,res) -> res.send 404,'Not found =('

server.listen 8080