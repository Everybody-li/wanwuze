-- ##Title app-应聘-应聘方式管理-目标工作管理-创建目标工作-判断是否已经重复创建该工作事项的工作信息
-- ##Author lith
-- ##CreateTime 2023-09-14
-- ##Describe
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input valueSum int[>0] NULL;已选的行政区域值总和
-- ##input curUserId char[36] NOTNULL;登录用户id

-- ##output existsCount int[>=0] 0;工作信息重复数量，0-表示未重复，>0表示已重复


select count(1) existsCount
from (select t1.guid as recruitGuid
      from coz_chat_employ t1
               inner join coz_chat_employ_detail t2
                          on t1.guid = t2.employ_guid
      where t1.user_id = '{curUserId}' and t1.del_flag='0'
        and t1.category_guid = '{categoryGuid}'
      group by t1.guid) t


