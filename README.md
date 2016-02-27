### purescript-pouchdb

<a href="http://pouchdb.com/">PouchDB</a> Bindigs for <a href="http://purescript.org">PureScript</a> (Work in Progress)

PouchDB is an open-source Database inspired by <a href="http://couchdb.apache.org/">Apache CouchDB</a> that runs in the browser.

With PouchDB one can store app-data locally *while offline* and sync them with the CouchDB and compatible servers when the app is back online.

### Implementation Status

- <a href="http://pouchdb.com/api.html#create_database">Create a database</a>
- <a href="http://pouchdb.com/api.html#database_information">Get database information</a>
- <a href="http://pouchdb.com/api.html#delete_database">Delete a database</a>
- <a href="http://pouchdb.com/api.html#create_document">Using put</a>

<img src="http://fs5.directupload.net/images/160227/6vmykjw9.png"/>

### Building

*Library*
```shell
pulp dep install [initial build only]
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
pulp test
```

### Running

*NodeJS + Hapi*

```shell
npm start
```

*then open* <a href="http://localhost:8080">http:://localhost:8080</a>

### Demo App

Open your browser's console to see the output from PouchDB

<img src="http://fs5.directupload.net/images/160227/gz5i4pth.png"/>