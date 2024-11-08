-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-购方用户成果-二维码-查看供应渠道-查看详情-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-25
-- ##Describe 查询 t1.需方是入参需方用户,报价方式是二维码,t1.供方是入参供方用户,t5.lgcode_guid是入参supplyLgCodeGuid的数据
-- ##Describe 表名:coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_detail t2,sys_app_user t3,coz_org_info_lgcode t4,coz_cattype_sd_path t5
-- ##CallType[QueryData]

-- ##input supplyUserPhone string[50] NULL;购方信息,模糊搜索
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input demandUserId char[36] NOTNULL;需方用户id
-- ##input supplyUserId char[36] NOTNULL;供方用户id
-- ##input supplyLgCodeGuid char[36] NOTNULL;供方登录系统guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output orgUserId char[36] ;供应机构guid
-- ##output operationTime char[19] 2023-12-12 12:23:45;办理申请点击日期
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output orgName string[100] ;供应机构(渠道)名称
-- ##output modelName string[50] ;型号名称
-- ##output supplyUserPhone string[50] (+86)18650767213;购方信息

select 
t4.user_id as orgUserId
,left(t2.create_time,19) as operationTime
,t5.name as categoryName
,t5.cattype_name as cattypeName
,t4.name as orgName
,t1.biz_name as modelName
,concat('(+86)',t1.supply_user_phone) as supplyUserPhone
from 
coz_server3_cate_dealstatus_statistic_detail t1
inner join
coz_server3_cate_dealstatus_statistic t2
on t1.statistic_guid=t2.guid
inner join
coz_org_info t4
on t1.supply_user_id=t4.user_id
inner join
coz_category_info t5
on t2.category_guid=t5.guid
where t1.del_flag='0' 
and t1.supply_user_id='{supplyUserId}'
and t2.demand_user_id='{demandUserId}'
and (t1.supply_user_phone like '%{supplyUserPhone}%' or '{supplyUserPhone}'='')
and t1.price_way='2'
and left(t2.create_time,7)='{operationMonth}'
and exists(select 1 from coz_lgcode_fixed_data a inner join coz_org_info_lgcode b on b.lgcode_guid=a.guid where b.user_id=t4.user_id and a.del_flag='0' and b.del_flag='0' and a.guid='{supplyLgCodeGuid}')
order by t2.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};

