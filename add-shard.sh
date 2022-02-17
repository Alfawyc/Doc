#!/bin/sh


kubectl exec -it mongo-shard0-0 -- bash << EOF
mongo --host mongos.mongo-sharding << INTERNALEOF
sh.addShard("shard0/mongo-shard0-0.mongo-shard0.mongo-sharding:27020,mongo-shard0-1.mongo-shard0.mongo-sharding:27020,mongo-shard0-2.mongo-shard0.mongo-sharding:27020")
sh.addShard("shard1/mongo-shard1-0.mongo-shard1.mongo-sharding:27018,mongo-shard1-1.mongo-shard1.mongo-sharding:27018,mongo-shard1-2.mongo-shard1.mongo-sharding:27018")
sh.addShard("shard2/mongo-shard2-0.mongo-shard2.mongo-sharding:27019,mongo-shard2-1.mongo-shard2.mongo-sharding:27019,mongo-shard2-2.mongo-shard2.mongo-sharding:27019")
INTERNALEOF
EOF
