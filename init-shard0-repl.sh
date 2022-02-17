#!/bin/sh


kubectl exec -it mongo-shard0-0 -- mongo --port 27020 << EOF
config = {_id: 'shard0',
          members: [
           {_id: 0, host: 'mongo-shard0-0.mongo-shard0.mongo-sharding:27020'},
           {_id: 1, host: 'mongo-shard0-1.mongo-shard0.mongo-sharding:27020'},
           {_id: 2, host: 'mongo-shard0-2.mongo-shard0.mongo-sharding:27020', arbiterOnly:true}
	 ]
}
rs.initiate(config)
rs.status()
EOF
