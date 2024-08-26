# Promscale

## Add data node

```
psql -U timescale timescale
select add_data_node('timescale-002-bis', host => 'xxx', database => 'timescale_bis');
call add_prom_node('timescale-002-bis');
```

See [multinode](https://github.com/timescale/promscale/blob/master/docs/multinode.md) page.

## Set chunk interval

* `set_default_chunk_interval` for all chunks
* `set_metric_chunk_interval` for metric

See [API reference](https://github.com/timescale/promscale/blob/master/docs/sql_api.md).

## Set retention period

* `set_default_retention_period` for all chunks
* `set_metric_retention_period` for metric

See [API reference](https://github.com/timescale/promscale/blob/master/docs/sql_api.md).
