#!/bin/sh


#mongo-config-1.mongo-config.mongo-sharding
kubectl exec -it mongo-config-0 -- mongo --port 27027 << EOF
config = {_id: 'config', configsvr: true,
          members: [
           {_id: 0, host: 'mongo-config-0.mongo-config.mongo-sharding:27027'},
           {_id: 1, host: 'mongo-config-1.mongo-config.mongo-sharding:27027'}
	 ]
}
rs.initiate(config)
rs.status()
EOF
