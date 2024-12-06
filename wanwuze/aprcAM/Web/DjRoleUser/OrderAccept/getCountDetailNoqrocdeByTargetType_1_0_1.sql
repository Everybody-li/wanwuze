-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供方对接成果管理-非二维码-查看详情-查询列表上方括号内(订单验收通过)数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 目标所属类型的品类订单验收通过数量,按订单验收通过时间倒序,t1.业务guid=t3.guid
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t3,coz_demand_request t4
-- ##CallType[QueryData]

-- ##input orderNo string[50] NULL;采购编号,模糊搜索
-- ##input operationMonth char[7] 2023-12;统计时间(订单验收通过时间)
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] 10;数量

-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

-- 引入
{file[aprc/app/demand/dReq/plates/codeCondition_1_0_1.sql]/file}


select 
count(1) as totalNum
from 
coz_server3_cate_dealstatus_statistic t1
inner join
coz_order t3
on t1.biz_guid=t3.guid
inner join
coz_demand_request t4
on t3.request_guid=t4.guid
inner join
coz_org_info t5
on t3.supply_user_id=t5.user_id
where t1.del_flag='0' 
and t3.del_flag='0' 
and t4.del_flag='0' 
and t3.accept_status='1'
and (('{targetUserType}'='1' and t1.demand_sys_user_guid='{targetUserId}')
         or ('{targetUserType}'='2' and t1.supply_sys_user_guid='{targetUserId}')
         or ('{targetUserType}'='3' and t1.category_guid='{targetUserId}'))
and left(t3.accept_time,7)='{operationMonth}'
and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and t3.accept_time >= @bindTime))
    {dynamic:orderNo[ and t3.order_no like '%{orderNo}%']/dynamic}




