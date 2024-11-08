-- ##Title app-招聘方-根据末级场景和字节内容查询品类列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-招聘方-根据末级场景和字节内容查询品类列表
-- ##CallType[QueryData]

-- ##input treeName1 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName2 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName3 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName4 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName5 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName6 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName7 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName8 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName9 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName10 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output categoryGuid char[36] 品类名称guid;品类名称guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output alias string[50] 品类别名;品类别名（多个逗号分隔）
-- ##output img string[200] 品类图片地址;品类图片地址
-- ##output categoryMode int[>=0] 1;品类类型模式（1：沟通模式，2：交易模式）
-- ##output buttonStatus int[>=0] 1;操作按钮状态（1：供应(选择)，2：限制供应(选择)）
-- ##output buttonStatusName string[50] 操作按钮状态名称;操作按钮状态名称
-- ##output sdFlag string[50] demand;采购供应标志（demand：采购；后端固定返回demand）

set @col=concat(CAST('{treeName1}' AS char CHARACTER SET utf8),
                CAST('{treeName2}' AS char CHARACTER SET utf8),
                CAST('{treeName3}' AS char CHARACTER SET utf8),
                CAST('{treeName4}' AS char CHARACTER SET utf8),
                CAST('{treeName5}' AS char CHARACTER SET utf8),
                CAST('{treeName6}' AS char CHARACTER SET utf8),
                CAST('{treeName7}' AS char CHARACTER SET utf8),
                CAST('{treeName8}' AS char CHARACTER SET utf8),
                CAST('{treeName9}' AS char CHARACTER SET utf8),
                CAST('{treeName10}' AS char CHARACTER SET utf8),
                CAST('%' AS char CHARACTER SET utf8)) ;
PREPARE q1 FROM '
select
*
from
(
select
*
,''demand'' as sdFlag
from
(
select
t.categoryGuid
,t.categoryName
,t.alias
,t.img
,t.categoryMode
,t.id
,t.buttonStatus
,case when(t.buttonStatus=1) then t.btn_name_1 else t.btn_name_2 end as buttonStatusName
from
(
	select
	t.guid as categoryGuid
	,t.name as categoryName
	,t.alias
	,t.img
	,t.id
	,t.mode as categoryMode
	,case when (
	(exists(select 1 from coz_app_user_permission_detail where biz_guid=t.guid and user_id=''{curUserId}'' and type=5 and del_flag=0)) or (exists(select 1 from coz_app_user_permission where user_id=''{curUserId}'' and type=3 and del_flag=0 and status=1))
	) then 2 else 1 end as buttonStatus
	,t.create_time
	,t4.btn_name_1
	,t4.btn_name_2
	from
	coz_category_info t
	left join
	coz_category_supplydemand t1
	on t1.category_guid=t.guid
	left join
	coz_category_scene_tree t2
	on t1.scene_tree_guid=t2.guid
	left join
	coz_cattype_sd_path t3
	on t2.sd_path_guid=t3.guid
	left join
	coz_cattype_supply_path t4
	on t3.supply_path_guid=t4.guid
	where 
	t.del_flag=''0'' and t2.guid=''{secenGuid}'' and ((t.name like @col or @col=''%''))
)t
)t
)t
order by t.buttonStatus,t.id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;