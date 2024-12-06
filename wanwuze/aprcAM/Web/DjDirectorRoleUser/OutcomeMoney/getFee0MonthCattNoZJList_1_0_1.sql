-- ##Title web-服务主管操作管理-服务主管业绩管理-购方/供方对接业绩管理-服务免费-非资金资源需求-产品费用月度详情-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-20
-- ##Describe 查询当前服务主管的业绩列表:某一月份下,查询归属服务主管的服务专员列表,求和与服务主管关联的corder的产品费用(supply_fee),按服务专员和corder的验收通过时间的年份和月度分组统计,排序先待定
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t2的服务主管guid是入参目标用户id,cdr的收取服务费是免费,品类类型是非资金资源需求
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2,coz_order corder,coz_demand_request cdr,coz_demand_request_price cdrp,coz_cattype_fixed_data cfd,sys_user su
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input month char[7] NOTNULL;计酬月份,格式:0000-00
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input phonenumber string[30] NULL;姓名或联系电话(模糊搜索)

-- ##output userName string[50] 账号名称;账号名称
-- ##output createTime char[19] 2023-12-12 12:23:45;账号开通日期
-- ##output nickName string[50] 姓名;姓名
-- ##output phonenumber string[50] 联系电话;联系电话
-- ##output month string[7] 计酬月份;计酬月份
-- ##output orderFee string[50] 采购服务费用;采购服务费用
-- ##output djUserGuid char[36] 服务专员用户id;服务专员用户id


-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

select
*
from
(
select 
left(t3.accept_time,7) as month
,left(t5.create_time,7) as createTime
,t5.user_name as userName
,t5.nick_name as nickName
,concat('(+86)',t5.phonenumber) as phonenumber
,sum(CAST((t3.supply_fee/100) AS decimal(18,2))) as orderFee
,t5.user_id as djUserGuid
from 
coz_server3_cate_dealstatus_statistic t1
inner join
coz_server3_cate_dealstatus_statistic_outcome t2
on t1.guid = t2.statistic_guid
inner join
coz_order t3
on t1.biz_guid = t3.guid
inner join
coz_demand_request t4
on t4.guid = t3.request_guid
inner join
sys_user t5
on (('{catTreeCode}' = 'demand' and t1.demand_sys_user_guid =t5.user_id) or ('{catTreeCode}' = 'supply' and t1.supply_sys_user_guid = t5.user_id))
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0'
  and t4.del_flag = '0'
  and t1.dstatus in (220, 322)
  and t3.accept_status = '1'
  and t4.done_flag = '1'
  and (t2.cat_tree_code = '{catTreeCode}')
  and t2.sys_user_guid = '{targetUserId}' and (t5.nick_name like '%{phonenumber}%' or t5.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
  and t4.serve_fee_flag='0' and left(t3.accept_time,7)='{month}' and t1.cattype_guid<>'43cabc5d-f1ce-11ec-bace-0242ac120003'
  and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and t3.accept_time >= @bindTime))
group by left(t3.accept_time, 7),left(t5.create_time, 7),t5.user_name,t5.phonenumber,t5.user_id
)t
order by createTime desc
Limit {compute:[({page}-1)*{size}]/compute},{size};