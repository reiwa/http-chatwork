## [cycle-http-chatwork-driver](https://www.npmjs.com/package/@sakana/http-chatwork)

A Cycle.js Driver for making HTTP requests

-- --

This is wrapper library of [ChatWork](www.chatwork.com/ja) for [Cycle.js](http://cycle.js.org). Even if there is not cycle, it works.

[About ChatWork API](http://developer.chatwork.com/ja/index.html)

-- --

Install

    npm i @sakana/http-chatwork rx @cycle/http

-- --

Sample

    { Observable } = require "rx"
    { run } = require "@cycle/core"
    { makeHTTPChatworkDriver } = require "@sakana/httpChatwork"

    main = (res) ->
        { HTTPChatwork } = res

        HTTPChatwork
        .forEach (o) -> console.log o

        $chatworkReq =
            Observable.interval 2000
            .map ->
                method : "GET"
                endpoint : [ "my", "status" ]

        HTTPChatwork : $chatworkReq

    drivers =
        HTTPChatwork : makeHTTPChatworkDriver token

    run main, drivers

Use a value called X-ChatWorkToken

    token = "4xexbx7xbxbx2xcx4xex4x4x3xax5xfx"

Check the [reference](http://developer.chatwork.com/ja/authenticate.html) about authenticate.

    drivers =
        HTTPChatwork : makeHTTPChatworkDriver token

`main` return `Observable` to Driver`.

    const main = (res) ->
        $chatworkReq =
            Observable.interval 2000
            .map ->
                method : "GET"
                endpoint : [ "my", "status" ]

        HTTPChatwork : $chatworkReq

`Driver` return data to `main`

const main = (res) ->
    { HTTPChatwork } = res

    HTTPChatwork
    .forEach (o) -> console.log o

`run cycle`

    run main, drivers

-- --

No Cycle.js

    chatwork = Chatwork "4xexbx7xbxbx2xcx4xex4x4x3xax5xfx"

require `Observable` if necessary

    { Observable } = require "rx"

-- --

The return value is `Observable`

    chatwork.get.me # GET : /me
    .from Observable.interval 1000

No argument

    chatwork.get.me
    .from()

Observable.map

    chatwork.get.me
    .from()
    .map (o) ->
        name    : o.name
        room_id : o.room_id

Observable.forEach

    chatwork.get.me
    .from()
    .map (o) ->
        name    : o.name
        room_id : o.room_id
    .forEach (o) ->
        console.log o

-- --

For example

    chatwork
    .get # method
    .endpoint1 # endpoint1
    .endpoint2 # endpoint2
    .from() # Observable

or array

    chatwork.get.endpoint [ "api1" "api2" ] # endpoint
    .from()

or string

    chatwork.get.endpoint "api1/api2"
    .from()

use query

    chatwork.get.endpoint1.endpoint2
    .query do
        query1 : 12345
        query2 : 23456
    .from()

-- --

Observable.flatMap

    chatwork.get.endpoint1.endpoint2
    .from()
    .flatMap (o) ->
        Observable.from o

-- --

End point : [GET /me](http://developer.chatwork.com/ja/endpoint_me.html)

    chatwork.get.me
    .from()
    .forEach (o) -> console.log o

    # or

    chatwork.get.endpoint [ "me" ]
    .from()
    .forEach (o) -> console.log o

-- --

End point : [GET /my](http://developer.chatwork.com/ja/endpoint_my.html#GET-my-status)

    chatwork.get.my.status
    .from()
    .forEach (o) -> console.log o

    # or

    chatwork.get.endpoint [ "my" "status" ]
    .from()
    .forEach (o) -> console.log o

-- --

End point : [POST /rooms](http://developer.chatwork.com/ja/endpoint_rooms.html#POST-rooms)

    chatwork.post.rooms
    .query do
        description : "description"
        icon_preset : "group"
        members_admin_ids : "12345" # 12345 is account_id
        members_member_ids : [ "23456" "34567" ]
        members_readonly_ids : [ "45678" "56789" ]
        name : "group_name"
    .from()
    .forEach (o) -> console.log o

    # or

    chatwork.post.endpoint "rooms"
    .query do
        description : "description"
        icon_preset : "group"
        members_admin_ids : "12345"
        members_member_ids : [ "23456" "34567" ]
        membegtrs_readonly_ids : [ "45678" "56789" ]
        name : "group_name"
    .from()
    .forEach (o) -> console.log o

-- --

End point : [PUT /rooms/room_id](http://developer.chatwork.com/ja/endpoint_rooms.html#PUT-rooms-room_id)

    chatwork.put.endpoint [ "rooms" "12345" ] # 12345 is room_id
    .query do
        description : "description_update"
        icon_preset : "check"
        name : "group_name_update"
    .from()
    .forEach (o) -> console.log o

    # or

    chatwork.put.rooms.room_id("12345")
    .query do
        description : "description_update"
        icon_preset : "check"
        name : "group_name_update"
    .from()
    .forEach (o) -> console.log o

-- --

End point : [DELETE /rooms/room_id](http://developer.chatwork.com/ja/endpoint_rooms.html#DELETE-rooms-room_id)

    chatwork.delete.endpoint [ "rooms" "12345" ] # 12345 is room_id
    .query do
        action_type : "delete"
    .from()
    .forEach (o) -> console.log o

    # or

    chatwork.delete.rooms.room_id("12345")
    .query do
        action_type : "delete"
    .from()
    .forEach (o) -> console.log o

-- --

End point : [GET /rooms/room_id](http://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-members)

    chatwork.get.endpoint [ "rooms" "12345" "members" ]
    .from()
    .forEach (o) -> console.log o

    # or

    chatwork.get.rooms.room_id(12345).members
    .from()
    .forEach (o) -> console.log o
