-- ##Title web-运营经理操作管理-品类供应管理-供应渠道信息管理-供应(机构)渠道-上方括号内总数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 统计供方数量(t1的行数,按t1.guid去重)
-- ##Describe 表名：coz_category_supplier t1,coz_org_info t2,coz_org_info_lgcode t3,coz_lgcode_fixed_data t4
-- ##CallType[QueryData]

-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] ;供应(机构)渠道数量


select 
count(1) as totalNum
from 
(select a.category_guid from coz_category_supplier a where a.del_flag='0' and exists(select 1 from coz_org_info where del_flag='0' and user_id=a.user_id)  
group by a.category_guid,a.user_id
)a 
