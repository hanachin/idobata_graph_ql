IdobataGraphQL
==============

[Idobata public GraphQL API](https://idobata.io/ja/api) client.

Installation
----

    % gem install idobata_graph_ql

Usage
-----

    % export IDOBATA_TOKEN=<YOUR_TOKEN_HERE>

Then

    require 'idobata_graph_ql'

    p IdobataGraphQL.query('query { viewer { name } }')
    # {"viewer"=>{"name"=>"idobata-fs"}}

    room_id = IdobataGraphQL.rooms.first.id
    p IdobataGraphQL.create_message(room_id, "hi")
    # {"createMessage"=>{"clientMutationId"=>nil}}
