-- ##Title web-查询各类角色用户管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询各类角色用户管理列表
-- ##Describe 场景专员：sceneRole
-- ##Describe 品类专员：categoryRole
-- ##Describe 型号专员：modelRole
-- ##Describe 定价专员：priceRole
-- ##Describe 信息专员：customerServiceRole
-- ##Describe 结算专员：settleRole
-- ##Describe 仲裁专员：judgeRole
-- ##Describe 引导经理：GuidanceJLRole
-- ##Describe 引导主管：GuidanceZGRole
-- ##Describe 引导专员：GuidanceStaffRole 
-- ##Describe 服务经理：serveManagerRole
-- ##Describe 服务主管：serveDirectorRole
-- ##Describe 用户专员：dxzyRole
-- ##Describe 招募专员：zmhrRole
-- ##Describe 供应专员：gyRole
-- ##Describe 用户专员：userAdminRole
-- ##Describe 询价调度专员：askPriceRole 
-- ##Describe 询价专员：askPriceStaffRole
-- ##Describe 交易专员：dealStaffRole
-- ##Describe 沟通调度专员：commuRole
-- ##Describe 沟通专员：commuStaffRole
-- ##Describe 服务调度专员：serveRole
-- ##Describe 服务专员：serveStaffRole
-- ##Describe 供应专员2：gy2Role
-- ##Describe 图片专员：imgRole
-- ##Describe 供需专员：modelSonRole
-- ##Describe 服务专员: duijieRole
-- ##Describe 上架专员: shangjiaRole
-- ##Describe 选拔专员: xuanbaMode3Role
-- ##Describe 服务主管 duijieDirectorRole
-- ##CallType[QueryData]

-- ##input roleKey string[100] NOTNULL;角色权限字符串，必填
-- ##input phonenumber string[11] NULL;电话号码，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input page int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input size int[>=0] NOTNULL;第几页（默认1），必填

-- ##output userId int[>=0] 10;
-- ##output userName string[50] 用户账号;用户账号
-- ##output accountStatus string[1] 1;账号状态（0-开启，1-停用）
-- ##output roleName string[30] 角色名称;角色名称
-- ##output nickName string[30] 用户姓名;用户姓名
-- ##output nation string[30] 国家;国家/地区
-- ##output phonenumber string[11] 直接下属用户手机号;直接下属用户手机号
-- ##output createTime string[16] 账号开通日期;账号开通日期(格式：0000-00-00 00:00)


PREPARE q1 FROM '
select
t.user_id as userId
,t1.user_name as userName
,t1.status as accountStatus
,t2.role_name as roleName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
,left(t1.create_time,16) as createTime
,t3.ex_value as workNo
from
sys_user_role t
left join
sys_user t1
on t1.user_id=t.user_id
left join
sys_role t2
on t2.role_id=t.role_id
left join
sys_user_extra t3
on t1.user_id=t3.user_guid and t3.ex_key=1
where t2.role_key=''{roleKey}'' and t1.del_flag=''0'' and (t1.phonenumber like ''%{phonenumber}%'' or t1.nick_name like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t1.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;