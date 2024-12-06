select
concat(left(now()+0,8),right(concat('00000000','{url:[http://127.0.0.1:8011/Cache?Name=judgeFeeNo&Key={yyyyMMdd}]/url}'),6)) as feeNo