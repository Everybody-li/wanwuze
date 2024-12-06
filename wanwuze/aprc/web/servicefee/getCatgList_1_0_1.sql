-- ##Title web-查询交易服务定价列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易服务定价列表
-- ##CallType[QueryData]

-- ##input categoryName string[500] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output serviceFeeGuid string[50] 服务费guid;服务费guid
-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称

PREPARE q1 FROM '

select t1.category_guid  as categoryGuid
     ,t2.name as categoryName
     ,t2.cattype_name as cattypeName
     , t1.serve_fee_flag as serve_fee_flag
from coz_category_service_fee fee
         right join (select drl.category_guid, drl.serve_fee_flag
                     from coz_category_deal_rule_log drl
                              inner join (select category_guid, max(id) as MID
                                          from coz_category_deal_rule_log
                                           where del_flag = ''0''
					   group by category_guid
                     ) drlMid on drl.id = drlMid.MID
                     where drl.serve_fee_flag = 1
) t1 on fee.category_guid = t1.category_guid
         inner join coz_category_info t2 on t1.category_guid = t2.guid
where (t2.name like ''%{categoryName}%'' or ''{categoryName}'' = '''')  and t2.del_flag = ''0'' 
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;


