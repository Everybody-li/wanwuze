-- ##Title 运营经理-渠道选拔管理-根据供应管理系统guid查询供方列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 一个机构系统下可能有多个采购供应路径,按t2.guid,t3.user_id 分组
-- ##Describe 表名:表名:coz_cattype_sd_path t1,coz_org_info_lgcode t2,coz_org_info t3,coz_lgcode_fixed_data t4
-- ##CallType[QueryData]

-- ##input supplyLgCodeGuid string[36] NULL供方;登录系统guid
-- ##input orgName string[50] NULL;机构名称,模糊搜索
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output supplyLgCodeGuid char[36] 供方登录系统guid;供方登录系统guid
-- ##output loginCode string[2] 授权登录系统code;授权登录系统code
-- ##output supplyUserId char[36] 供方用户id(机构用户id);供方用户id(机构用户id)
-- ##output sdPathGuids string[1000] 逗号分隔的采购供应路径guid;逗号分隔的采购供应路径guid

select org.org_ID                       as orgID
     , left(org.create_time, 16)        as createTime
     , org.name                         as orgName
     , concat('(+86)', org.phonenumber) as phonenumber
     , lgfd.login_sysname               as supplySystem
     , lgfd.login_code                  as loginCode
     , t1.lgcode_guid                   as supplyLgCodeGuid
     , org.user_id                      as supplyUserId
     , concat('\'', t1.guid, '\'')      as sdPathGuids
from coz_cattype_sd_path t1
         inner join coz_org_info_lgcode orglg on t1.lgcode_guid = orglg.lgcode_guid
         inner join coz_org_info org on org.user_id = orglg.user_id
         inner join coz_lgcode_fixed_data lgfd on lgfd.guid = orglg.lgcode_guid
where t1.del_flag = '0'
  and orglg.del_flag = '0'
  and org.del_flag = '0'
  and orglg.lgcode_guid = '{supplyLgCodeGuid}'
  and ('{orgName}' = '' or org.name like '%{orgName}%')
group by org.org_ID, orglg.lgcode_guid
order by createTime
Limit {compute:[({page}-1)*{size}]/compute},{size};

