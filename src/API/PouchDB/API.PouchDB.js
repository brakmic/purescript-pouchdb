
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
            console.error('[API ' + api + '] ' + err);
          });
          return {};
        }
      };
    }
    return cb;
};

var extractOptions = function(options){
  var op = {
      "name" : null,
      "adapter": null,
      "auto_compaction": null,
      "revs_limit": null,
      "skip_setup": null,
      "storage": null,
      "size": null,
      "location": null,
      "createFromLocation": null,
      "androidDatabaseImplementation": null,
      "db": null,
      "ajax": {},
      "auth": {}

  };
  var _l = null;
  var _r = null;
  var _o = null;
  if(options || (options.constructor &&
    options.constructor.name != 'Nothing')){
    if(!hasPackedValues(options))return {}; //defect options object received!
    //OK options BEGIN
    _o = options.value0.value0;
    //must be present or at least as a first param in _pouchDB()!
    op.name = _o.name.value0 ? _o.name.value0 : null;
    _l = hasPackedValues(_o.local.value0) ? _o.local.value0.value0 : null;
    if(_l){
        op.adapter         = _l.adapter.value0; //if undefined pochDB will infer it
        op.auto_compaction = _l.auto_compaction;
        op.revs_limit      = _l.revs_limit;
    }
    _r = hasPackedValues(_o.remote) ? _o.remote.value0 : null;
    if(_r){
      op.ajax =  hasPackedValues(_r.ajax) ? _r.ajax.value0 : null;
      op.auth = hasPackedValues(_r.auth) ? _r.auth.value0 : null;
    }
    //OK options END
  }
  return op;
}

var _pouchDB = function(name){
  return function(options){
    var _options = extractOptions(options);
    return function(){
      var _name = null;
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
        cb(db.destroy(_options))();
        return {};
      };
    };
  };
};

var _put = function(doc){
  var _doc = doc.value0 ? doc.value0 : doc;
  return function(docId){
    var _docId = docId.value0 ? docId.value0 : null;
    return function(docRev){
      var _docRev = docRev.value0 ? docRev.value0 : null;
      return function(options){
        var _options = extractOptions(options);
        return function(callback){
          var cb = createCallback('put', callback);
          return function(db){
            return function(){
              cb(db.put(doc.value0,_docId,_docRev,_options))();
              return {};
            };
          };
        };
      };
    };
  };
};

var _post = function(doc){
  var _doc = doc.value0 ? doc.value0 : doc;
  return function(options){
    var _options = extractOptions(options);
    return function(callback){
      var cb = createCallback('post', callback);
      return function(db){
        return function(){
          cb(db.post(_doc,_options))();
          return {};
        };
      };
    };
  };
};

var _get = function(docId){
  return function(options){
    var _options = extractOptions(options);
    return function(callback){
      var cb = createCallback('get', callback);
      return function(db){
        return function(){
          cb(db.get(docId, _options))();
          return {};
        };
      };
    };
  };
};

var _remove = function(doc){
  var _doc = doc.value0 ? doc.value0 : doc;
  return function(options){
    var _options = extractOptions(options);
    return function(callback){
      var cb = createCallback('remove', callback);
      return function(db){
        return function(){
          cb(db.remove(_doc,_options))();
          return {};
        };
      };
    };
  };
};

var _removeDocRev = function(doc){
  var _doc = doc.value0 ? doc.value0 : doc;
  return function(options){
    var _options = extractOptions(options);
    return function(callback){
      var cb = createCallback('removeDocRev', callback);
      return function(db){
        return function(){
          cb(db.remove(_doc._id, _doc._rev, _options))();
          return {};
        };
      };
    };
  };
};

var hasPackedValues = function(obj){
  return (obj &&
          obj.value0);
}

/* HELPERS */

var logRaw = function(str) {
  return function () {
    console.log(str);
    return {};
  };
};

module.exports = {
  logRaw       : logRaw,
  pouchDB      : _pouchDB,
  info         : _info,
  destroy      : _destroy,
  put          : _put,
  post         : _post,
  get          : _get,
  remove       : _remove,
  removeDocRev : _removeDocRev
};