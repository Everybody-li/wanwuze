-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-购方用户成果-二维码-查看供应渠道-查看详情-列表上方-办理申请点击括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询 t1.需方是入参需方用户,报价方式是二维码,t1.供方是入参供方用户的数量
-- ##Describe 表名:coz_server3_cate_dealstatus_statistic_detail t1,sys_app_user t2
-- ##CallType[QueryData]

-- ##input supplyUserPhone string[50] NULL;购方信息,模糊搜索
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input demandUserId char[36] NOTNULL;需方用户id
-- ##input supplyUserId char[36] NOTNULL;供方用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input supplyLgCodeGuid char[36] NOTNULL;供方登录系统guid

-- ##output totalNum int[>=0] ;办理申请点击数量

select 
count(1) as totalNum
from 
coz_server3_cate_dealstatus_statistic_detail t1
inner join
coz_server3_cate_dealstatus_statistic t2
on t1.statistic_guid=t2.guid
inner join
coz_org_info t4
on t1.supply_user_id=t4.user_id
where t1.del_flag='0' 
and t1.supply_user_id='{supplyUserId}'
and t2.demand_user_id='{demandUserId}'
and (t1.supply_user_phone like '%{supplyUserPhone}%' or '{supplyUserPhone}'='')
and t1.price_way='2'
and exists(select 1 from coz_lgcode_fixed_data a inner join coz_org_info_lgcode b on b.lgcode_guid=a.guid where b.user_id=t4.user_id and a.del_flag='0' and b.del_flag='0' and a.guid='{supplyLgCodeGuid}')
and left(t1.create_time,7)='{operationMonth}'


