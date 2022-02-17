#!/bin/sh


kubectl exec -it mongo-shard2-0 -- mongo --port 27019 << EOF
config = {_id: 'shard2',
          members: [
           {_id: 0, host: 'mongo-shard2-0.mongo-shard2.mongo-sharding:27019'},
           {_id: 1, host: 'mongo-shard2-1.mongo-shard2.mongo-sharding:27019'},
           {_id: 2, host: 'mongo-shard2-2.mongo-shard2.mongo-sharding:27019', arbiterOnly:true}
	 ]
}
rs.initiate(config)
rs.status()
EOF
