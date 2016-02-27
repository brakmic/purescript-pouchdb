
// module API.PouchDB

const _PouchDB = require('pouchdb');

//This is a helper for creating internal callbacks to process responses.
var createCallback = function(api, callback){
  var cb = null;
  if(callback.value0){
    callback = callback.value0;
  }
  if(callback &&
       callback.constructor &&
       callback.constructor.name == 'Nothing'){
        cb = function(ignore){
              var ignr = ignore.then(function(){
                  return {};
               }).catch(function(error){
                  console.log(api + ' failed, error: ' + error);
            });
          var ret = function(){
            return ignr;
          };
          return ret;
      };
    } else {
      cb = function(val){
        return function(){
          val.then(function(v){
            callback(v)();
          }).catch(function(err){
            console.error(err);
          });
          return {};
        }
      };
    }
    return cb;
};

var extractOptions = function(options){
  var _options = null;
  if(!options || (options.constructor &&
    options.constructor.name == 'Nothing')){
    _options = {};
  }else{
    _options = options.value0;
  }
  return _options;
}

var _pouchDB = function(name){
  return function(options){
    return function(){
      var _name = null;
      var _options = extractOptions(options);
      if(name && name.value0){
        _name = name.value0;
      }else{
        if(_options.name)
        _name = _options.name;
      }
      var db = new _PouchDB(_name, _options);
      return db;
    };
  };
};

var _info = function(callback){
  var cb = createCallback('info', callback);
  return function(db){
    return function(){
      cb(db.info())();
      return {};
    }
  };
};

var _destroy = function(options){
  var _options = extractOptions(options);
  return function(callback){
  var cb = createCallback('destroy', callback);
    return function(db){
      return function(){
        cb(db.destroy(options))();
        return {};
      };
    };
  };
};

/* HELPERS */

var logRaw = function(str) {
  return function () {
    console.log(str);
    return {};
  };
};

module.exports = {
  logRaw  : logRaw,
  pouchDB : _pouchDB,
  info    : _info,
  destroy : _destroy
};