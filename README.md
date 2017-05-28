IdobataGraphQL
==============

[Idobata public GraphQL API](https://idobata.io/ja/api) client.

Usage
-----

    require 'idobata_graph_ql'
    p IdobataGraphQL.query('query { viewer { name } }')
    {"viewer"=>{"name"=>"idobata-fs"}}
