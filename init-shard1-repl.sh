#!/bin/sh


kubectl exec -it mongo-shard1-0 -- mongo --port 27018 << EOF
config = {_id: 'shard1',
          members: [
           {_id: 0, host: 'mongo-shard1-0.mongo-shard1.mongo-sharding:27018'},
           {_id: 1, host: 'mongo-shard1-1.mongo-shard1.mongo-sharding:27018'},
           {_id: 2, host: 'mongo-shard1-2.mongo-shard1.mongo-sharding:27018', arbiterOnly:true}
	 ]
}
rs.initiate(config)
rs.status()
EOF
