
// module API.PouchDB

const _PouchDB = require('pouchdb');
const _ = require('underscore');

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
  //var _doc = extractDoc(doc);
  return function(docId){
    //var _docId = docId.value0 ? docId.value0 : null;
    return function(docRev){
      //var _docRev = docRev.value0 ? docRev.value0 : null;
      return function(options){
        var _options = extractOptions(options);
        return function(callback){
          var cb = createCallback('put', callback);
          return function(db){
            return function(){
              var _doc = createDoc(doc,docId,docRev);
              cb(db.put(_doc,null,null,_options))();
              return {};
            };
          };
        };
      };
    };
  };
};

var _post = function(doc){
  var _doc = extractDoc(doc);
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
  var _doc = extractDoc(doc);
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
  var _doc = extractDoc(doc);
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

var _bulkDocs = function(docs){
  var _docs = [];
  _.each(docs, function(doc){
    _docs.push(extractDoc(doc));
  });
  return function(options){
    var _options = extractOptions(options);
    return function(callback){
      var cb = createCallback('bulkDocs', callback);
      return function(db){
        return function(){
          cb(db.bulkDocs(_docs, _options))();
          return {};
        };
      };
    };
  };
};

var _allDocs = function(options){
  var _options = extractOptions(options);
  return function(callback){
    var cb = createCallback('allDocs', callback);
    return function(db){
      return function(){
        cb(db.allDocs(_options))();
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

var extractDoc = function(doc){
  if(!doc)return null;
  var _doc = doc.value0 ? doc.value0 : doc;
  if(_doc._rev && _doc._rev.value0){
    _doc._rev = _doc._rev.value0;
  }else if(Object.keys(_doc._rev).length === 0){
    delete _doc._rev;
  }
  if(_doc._id && _doc._id.value0){
    _doc._id = _doc._id.value0;
  }else if(Object.keys(_doc._id).length === 0){
    delete _doc._id;
  }
  //_doc._rev = (_doc._rev && _doc._rev.value0) ? _doc._rev.value0 : null;
  //_doc._id = (_doc._id && _doc._id.value0) ? _doc._id.value0 : null;
  //console.log('[EXTRACT-DOC] ' + JSON.stringify(_doc, null, 4));
  return _doc;
};

var createDoc = function(doc, id, rev){
    doc = doc.value0 ? doc.value0 : doc;
    doc._id = id.value0 ? id.value0 : null;
    doc._rev = rev.value0 ? rev.value0 : null;
    return doc;
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
  removeDocRev : _removeDocRev,
  bulkDocs     : _bulkDocs,
  allDocs      : _allDocs
};