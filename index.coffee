{ Observable } = require 'rx'
{ makeHTTPDriver } = require '@cycle/http'

makeHTTPChatworkDriver = (token) ->
    HTTP = do makeHTTPDriver
    (res) ->
        HTTP res.map (o) ->
            headers : 'X-ChatWorkToken' : token
            method : o.method
            url : 'https://api.chatwork.com/v1/' +
                if Array.isArray o.endpoint then o.endpoint.join('/') else o.endpoint
        .filter (o) -> true # o.request.url is 'https://api.chatwork.com/v1/me'
        .mergeAll()
        .map (o) ->
            o.body

HTTPChatwork = (token) ->

    http = makeHTTPChatworkDriver token

    send = (o) ->
        observable = if o.observable then o.observable else Observable.just 'chatwork.com'
        http observable.map ->
                method : o.method
                endpoint : o.endpoint

    get :
        me :
            from : (observable) ->
                send # me
                    method : 'GET'
                    endpoint : [ 'me' ]
                    observable : observable
        my :
            status :
                from : (observable) ->
                    send # my/status
                        method : 'GET'
                        endpoint : [ 'my', 'status' ]
                        observable : observable
            tasks :
                from : (observable) ->
                    send # my/tasks
                        method : 'GET'
                        endpoint : [ 'my', 'tasks' ]
                        observable : observable
                query : (query) ->
                    from : (observable) ->
                        send # my/tasks (query)
                            method : 'GET'
                            endpoint : [ 'my', 'tasks' ]
                            query : query
                            observable : observable
        contacts :
            from : (observable) ->
                send # contacts
                    method : 'GET'
                    endpoint : [ 'contacts' ]
                    observable : observable
        rooms :
            from : (observable) ->
                send # rooms
                    method : 'GET'
                    endpoint : [ 'rooms' ]
                    observable : observable
            room_id : (room_id) ->
                from : (observable) ->
                    send # rooms/room_id
                        method : 'GET'
                        endpoint : [ 'rooms', room_id ]
                        observable : observable
                members :
                    from : (observable) ->
                        send # rooms/room_id/members
                            method : 'GET'
                            endpoint : [ 'rooms', room_id, 'members' ]
                            observable : observable
                messages :
                    from : (observable) ->
                        send # rooms/room_id/messages
                            method : 'GET'
                            endpoint : [ 'rooms', room_id, 'messages' ]
                            observable : observable
                    query : (query) ->
                        from : (observable) ->
                            send # rooms/room_id/messages (query)
                                method : 'GET'
                                endpoint : [ 'rooms', room_id, 'messages' ]
                                query : query
                                observable : observable
                    messages_id : (messages_id) ->
                        from : (observable) ->
                            send # rooms/room_id/messages/messages_id
                                method : 'GET'
                                endpoint : [ 'rooms', room_id, 'messages', messages_id ]
                                observable : observable
                tasks :
                    from : (observable) ->
                        send # rooms/room_id/tasks
                            method : 'GET'
                            endpoint : [ 'rooms', room_id, 'tasks' ]
                            observable : observable
                    query : (query) ->
                        from : (observable) ->
                            send # rooms/room_id/tasks (query)
                                method : 'GET'
                                endpoint : [ 'rooms', room_id, 'tasks' ]
                                query : query
                                observable : observable
                    task_id : (task_id) ->
                        from : (observable) ->
                            send # rooms/room_id/tasks/task_id
                                method : 'GET'
                                endpoint : [ 'rooms', room_id, 'tasks', task_id ]
                                observable : observable
                files :
                    from : (observable) ->
                        send # rooms/room_id/files
                            method : 'GET'
                            endpoint : [ 'rooms', room_id, 'files' ]
                            observable : observable
                    query : (query) ->
                        from : (observable) ->
                            send # rooms/room_id/files
                                method : 'GET'
                                endpoint : [ 'rooms', room_id, 'files' ]
                                query : query
                                observable : observable
                    file_id : (file_id) ->
                        from : (observable) ->
                            send # rooms/room_id/files/file_id
                                method : 'GET'
                                endpoint : [ 'rooms', room_id, 'files', file_id ]
                                observable : observable
                        query : (query) ->
                            from : (observable) ->
                                send # rooms/room_id/files/file_id
                                    method : 'GET'
                                    endpoint : [ 'rooms', room_id, 'files', file_id ]
                                    query : query
                                    observable : observable
        endpoint : (endpoint) ->
            from : (observable) ->
                send
                    method : 'GET'
                    endpoint : endpoint
                    observable : observable
            query : (query) ->
                from : (observable) ->
                    send
                        method : 'GET'
                        endpoind : endpoint
                        query : query
                        observable : observable
    post :
        rooms :
            query : (query) ->
                from : (observable) ->
                    send # rooms (query)
                        method : 'POST'
                        endpoint : [ 'rooms' ]
                        query : query
                        observable : observable
            room_id : (room_id) ->
                messages :
                    query : (query) ->
                        from : (observable) ->
                            send # rooms/room_id/members (query)
                                method : 'POST'
                                endpoint : [ 'rooms', room_id, 'messages' ]
                                query : query
                                observable : observable
                tasks :
                    query : (query) ->
                        from : (observable) ->
                            send # rooms/room_id/tasks
                                method : 'POST'
                                endpoint : [ 'rooms', room_id, 'tasks' ]
                                query : query
                                observable : observable
        endpoint : (endpoint) ->
            from : (observable) ->
                send
                    method : 'POST'
                    endpoint : endpoint
                    observable : observable
            query : (query) ->
                from : (observable) ->
                    send
                        method : 'POST'
                        endpoint : endpoint
                        query : query
                        observable : observable
    put :
        rooms :
            room_id : (room_id) ->
                from : (observable) ->
                    send # rooms/room_id
                        method : 'PUT'
                        endpoint : [ 'rooms', room_id ]
                        observable : observable
                query : (query) ->
                    from : (observable) ->
                        send # rooms/room_id (query)
                            method : 'PUT'
                            endpoint : [ 'rooms', room_id ]
                            query : query
                            observable : observable
                members :
                    query : (query) ->
                        from : (observable) ->
                            send
                                method : 'PUT'
                                endpoint : [ 'rooms', room_id, 'members' ]
                                query : query
                                observable : observable
        endpoint : (endpoint) ->
            from : (observable) ->
                send
                    method : 'PUT'
                    endpoint : endpoint
                    observable : observable
            query : (query) ->
                from : (observable) ->
                    send
                        method : 'PUT'
                        endpoint : endpoint
                        query : query
                        observable : observable
    delete :
        rooms :
            room_id : (room_id) ->
                query : (query) ->
                    from : (observable) ->
                        send # rooms/room_id
                            method : 'DELETE'
                            endpoint : [ 'rooms', room_id ]
                            query : query
                            observable : observable
        endpoint : (endpoint) ->
            from : (observable) ->
                send
                    method : 'DELETE'
                    endpoint : endpoint
                    observable : observable
            query : (query) ->
                from : (observable) ->
                    send
                        method : 'DELETE'
                        endpoint : endpoint
                        query : query
                        observable : observable

exports.makeHTTPChatworkDriver = makeHTTPChatworkDriver
exports.HTTPChatwork = HTTPChatwork
