-- ##Title app-供应-查看已添加的品类列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查看已添加的品类列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input categoryName string[500] NULL;品类名称(支持模糊搜索)，非必填
-- ##input sdPathGuids string[1000] NOTNULL; 逗号分隔的采购供应路径guid
-- ##input supplyUserId string[36] NOTNULL;供方用户id,必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output supplierGuid string[50] 供方品类表guid;供方品类表guid
-- ##output userId char[36] 用户id;用户id
-- ##output categoryGuid string[36] 品类guid;品类guid
-- ##output categoryName string[500] 品类名称;品类名称
-- ##output categoryImg string[200] 品类图片;品类图片
-- ##output categoryalias string[50] 品类别名;品类别名
-- ##output categoryMode int[>=0] 1;品类类型模式（1：沟通模式，2：交易模式）
-- ##output priceMode int[>=0] 1;供应需求节点页面格式（1：型号模式，2：按单模式）
-- ##output createTime string[19] 品类创建时间;品类创建时间
-- ##output rangeFlag int[>=0] 1;需求范围开关(0-关闭,代表需求范围内容无值，1-开启,代表需求范围内容有值)
-- ##output userPriceMode int[>=0] 1;方品类报价模式（1：型号模式，2：按单模式）


select
t1.guid as supplierGuid
,t1.user_id as userId
,t2.guid as categoryGuid
,t2.name as categoryName
,t2.img as categoryImg
,t2.alias as  categoryalias
,t2.mode as categoryMode
,t6.price_mode as priceMode
,t2.create_time as createTime
,t1.range_flag as rangeFlag
,t1.user_price_mode as userPriceMode
,t7.supply_path_guid as supplyPathGuid
,case when (t1.price_mode_chflag='1' and read_pm_chflag='1') then '1' else '0' end as priceModeChFlag
,case when (t1.price_mode_chflag='1' and read_pm_chflag='1') then concat('【',t2.name,'】的需求范围管理将从【',(case when (t1.price_mode='1') then '按单(模式)报价' else '型号(模式)报价' end),'】变更成【',(case when (t1.price_mode='1') then '型号(模式)报价' else '按单(模式)报价' end),'】') else '' end as priceModeChMsg
from
coz_category_supplier t1
inner join
coz_category_info t2
on t1.category_guid=t2.guid
inner join
coz_category_supplydemand t3
on t3.category_guid=t2.guid
inner join
coz_category_scene_tree t4
on t3.scene_tree_Guid=t4.guid
left join
sys_weborg_user t5
on t1.user_id=t5.guid
left join
(
select a.* from coz_category_deal_rule_log a
right join
(select category_guid,max(id) as MID from coz_category_deal_rule_log group by category_guid) b
on 
a.id=b.MID
)t6
on t1.category_guid=t6.category_guid
left join
coz_cattype_sd_path t7
on t4.sd_path_guid=t7.guid
where 
(t2.name like '%{categoryName}%' or '{categoryName}'='') and t1.user_id='{supplyUserId}'and t1.del_flag='0' and t2.del_flag='0' and t4.sd_path_Guid in ({sdPathGuids}) and t5.status='0'
group by t1.guid,t1.user_id,t2.guid,t2.name,t2.img,t2.alias,t2.mode,t6.price_mode,t2.create_time,t1.range_flag,t1.user_price_mode,t7.supply_path_guid
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};

