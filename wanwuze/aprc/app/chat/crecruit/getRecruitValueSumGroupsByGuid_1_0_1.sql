-- ##Title 查询供方已创建的招聘信息
-- ##Author lith
-- ##CreateTime 2023-07-14
-- ##Describe 查询供方已创建的招聘信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input valueSum int[>0] NOTNULL;已选的行政区域值总和，必填
-- ##input curUserId char[36] NOTNULL;登录用户id，必填

-- ##output existsCount int[>=0] 0;招聘信息重复数量，0-表示未重复，>0表示已重复


select count(*) existsCount
from coz_chat_recruit t1
         inner join coz_chat_recruit_detail t2
                    on t1.guid = t2.recruit_guid
where t1.user_id = '{curUserId}'
  and t1.category_guid = '{categoryGuid}'
  and t1.del_flag = '0'
  and t2.del_flag = '0'
;




