-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供方对接成果管理-非二维码-查看详情(订单验收通过)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 目标所属类型的品类订单验收通过数量,按订单验收通过时间倒序,t1.业务guid=t3.guid
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t3,coz_demand_request t4
-- ##CallType[QueryData]

-- ##input orderNo string[50] NULL;采购编号,模糊搜索
-- ##input operationMonth char[7] 2023-12;统计时间(订单验收通过时间)
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output operationTime char[19] 2023-12-12 12:23:45;订单验收通过日期
-- ##output orderNo string[50] 采购编号;采购编号
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output demandUserPhone string[50] (+86)18650767213;需方信息
-- ##output orgUserId char[36] ;供应机构guid
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号


-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

select
    t5.guid                         as orgUserId
  , left(t3.accept_time, 19)        as operationTime
  , t3.order_no                     as orderNo
  , t4.category_name                as categoryName
  , t4.cattype_name                 as cattypeName
  , concat('(+86)', t4.user_phone)  as demandUserPhone
  , t5.org_ID                       as orgID
  , left(t5.create_time, 19)        as createTime
  , (
        select a.login_sysname from coz_lgcode_fixed_data a where a.guid = t2.lgcode_guid and a.del_flag = '0'
    )                               as supplySystem
  , t5.name                         as orgName
  , concat('(+86)', t5.phonenumber) as phonenumber
from
    coz_server3_cate_dealstatus_statistic t1
    left join
        coz_cattype_sd_path               t2
            on t1.sd_path_guid = t2.guid
    inner join
        coz_order                         t3
            on t1.biz_guid = t3.guid
    inner join
        coz_demand_request                t4
            on t3.request_guid = t4.guid
    inner join
        coz_org_info                      t5
            on t3.supply_user_id = t5.user_id
where
      t1.del_flag = '0'
  and t3.del_flag = '0'
  and t4.del_flag = '0'
  and t3.accept_status = '1'
  and (('{targetUserType}' = '1' and t1.demand_sys_user_guid = '{targetUserId}') or
       ('{targetUserType}' = '2' and t1.supply_sys_user_guid = '{targetUserId}') or
       ('{targetUserType}' = '3' and t1.category_guid = '{targetUserId}'))
  and left(t3.accept_time, 7) = '{operationMonth}'
  and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and t3.accept_time >= @bindTime))
    {dynamic:orderNo[ and t3.order_no like '%{orderNo}%']/dynamic}
order by t3.accept_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



