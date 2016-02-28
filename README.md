### purescript-pouchdb

<a href="http://pouchdb.com/">PouchDB</a> Bindings for <a href="http://purescript.org">PureScript</a> (Work in Progress)

PouchDB is an open-source Database inspired by <a href="http://couchdb.apache.org/">Apache CouchDB</a> that runs in the browser.

With PouchDB one can store app-data locally *while offline* and sync them with the CouchDB and compatible servers when the app is back online.

### Implementation Status

- <a href="http://pouchdb.com/api.html#create_database">Create database</a>
- <a href="http://pouchdb.com/api.html#database_information">Get db-information</a>
- <a href="http://pouchdb.com/api.html#delete_database">Delete database</a>
- <a href="http://pouchdb.com/api.html#create_document">Put document</a>
- <a href="http://pouchdb.com/api.html#create_document">Post document</a>
- <a href="http://pouchdb.com/api.html#fetch_document">Fetch document</a>
- <a href="http://pouchdb.com/api.html#delete_document">Delete document</a>
- <a href=""http://pouchdb.com/api.html#batch_create>Batch upload</a>

<img src="http://fs5.directupload.net/images/160228/e5o7gse7.png"/>

### Building

*Library*
```shell
bower install [initial build only]
npm install [initial build only]
gulp
```

*Demo App*

```shell
gulp make-demo [initial build only]
gulp build-demo
```

*Tests*

```shell
npm test
```

### Running

*NodeJS + Hapi*

```shell
npm start
```

*then open* <a href="http://localhost:8080">http:://localhost:8080</a>

### Demo App

Open your browser's console to see the output from PouchDB

<img src="http://fs5.directupload.net/images/160227/8lpxp9az.png"/>

### License

<a href="https://github.com/brakmic/purescript-pouchdb/blob/master/LICENSE">MIT</a>