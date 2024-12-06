-- ##Title web后台-审批报价配置管理-品类审批报价管理-发布-判断是否可以发布
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe <p style="color:blue,font:bold">前端：每次查询前调用发布接口前调用品类名称是否存在接口判断品类是否存在，发现品类不存在，然后调用【web-删除供需需求信息】接口删除该行记录</p>
-- ##Describe 后端：判断是否可以发布
-- ##Describe 后端：如果当前品类已被删除(coz_category_info不存在该品类)，则返回否，提示语：品类专员已删除该品类名称，请刷新！
-- ##Describe 后端：如果当前品类是发布状态，则返回否，提示语：当前供需需求信息已经发布，请刷新！
-- ##Describe 后端：如果coz_category_am_modelprice的型号报价方式是二维码，则返回，提示语：“当前品类型号报价方式是二维码，无需发布！”
-- ##Describe
-- ##Describe 后端判断发布逻辑，采购需求信息和供应报价信息分别判断，判断该行品类的
-- ##Describe 采购需求信息：
-- ##Describe a：t1表没有添加任何板块，没有数据，则返回提示：采购需求信息未添加任何板块名称
-- ##Describe b：t1表没有产品板块，则返回提示：采购需求信息未添加产品板块名
-- ##Describe c：板块名称是否都有关联板块字段，如果存在N个板块没有关联字段名称的则返回提示：采购需求信息的【xxx】板块名称下没有字段名称，仅提示第1个板块名称即可
-- ##Describe d：板块字段名称是否都有关联板块名称，如果存在N个字段名称没有关联板块则返回提示：采购需求信息的【xxx】字段名称未关联板块名称，仅提示第1个字段名称即可
-- ##Describe e：字段名称存在t2.operation=0 或 字段名称的字段内容未配置 时，则返回提示：采购需求信息的【xxx】字段名称未配置完整，仅提示第1个字段名称即可
-- ##Describe 供应需求信息：
-- ##Describe h：t4表没有添加任何板块，没有数据，则返回提示：采购需求信息未添加任何板块名称
-- ##Describe i：t5表没有字段名称需包含“服务定价基数”(固化字段，code=f00051)和“报价失效时间”(固化字段：code=f00053)，则返回提示：供应报价信息未添加"固化字段名称服务定价基数或报价失效时间”
-- ##Describe j：板块名称是否都有关联板块字段，如果存在N个板块没有关联字段名称的则返回提示：供应报价信息的【xxx】板块名称下没有字段名称，仅提示第1个板块名称即可
-- ##Describe k：板块字段名称是否都有关联板块名称，如果存在N个字段名称没有关联板块则返回提示：供应报价信息的【xxx】字段名称未关联板块名称，仅提示第1个字段名称即可
-- ##Describe l：字段名称存在t5.operation=0 或 字段名称的字段内容未配置 时，则返回提示：供应报价信息的【xxx】字段名称未配置完整，仅提示第1个字段名称即可
-- ##Describe 说明：xxx代表板块名称或字段名称的变量值
-- ##Describe a、b、c、d、e、f 、h、i、j、k、l 任意条件成立，则表示不可发布，并返回对应提示信息，否则表示可以发布，提示信息返回空
-- ##Describe 表名：coz_model_am_modelprice_de_plate t1,coz_model_am_modelprice_de_plate_field t2,coz_model_am_modelprice_de_plate_field_content t3
-- ##Describe 表名：coz_model_am_modelprice_sp_plate t4,coz_model_am_modelprice_sp_plate_field t5,coz_model_am_modelprice_sp_plate_field_content t6
-- ##CallType[QueryData]

-- ##input bizGuid char[36] NOTNULL;业务guid：品类型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output canPublishFlag enum[0,1] 1;是否可以发布：0-否，1-是
-- ##output msg string[100] 操作提示语;操作提示语：”操作成功“或其他不可发布的提示信息

select
case 
when(existscategory='1' and publishFlag='1' and isdemandplate='1' and  isdemandfixeddata='1' and noInvaliddemandplate='1' and isdemandplatefield='1' and isdemandcontent='1' and issupplyplate='1' and issupplyfixeddata='1' and noInvalidsupplyplate='1' and issupplyplatefield='1' and issupplycontent='1' and issupplycontent='1' and issupplycontent='1' and qrcodeFlag='1') 
then 
'1'
else 
'0' 
end as canPublishFlag
,
case 
when (qrcodeFlag<>'1') 
then '当前品类型号报价方式是二维码，无需发布！'
when (existscategory<>'1') 
then '品类专员已删除该品类名称，请刷新！'
when (publishFlag<>'1') 
then '当前供需需求信息已经发布，请刷新！'
when (isdemandplate<>'1') 
then '采购需求信息未添加任何板块名称。'
when (isdemandfixeddata<>'1') 
then '采购需求信息未添加产品板块名。'
when (noInvaliddemandplate<>'1') 
then concat('采购需求信息的【',noInvaliddemandplate,'】','板块名称下没有字段名称')
when (isdemandplatefield<>'1') 
then concat('采购需求信息的【',isdemandplatefield,'】','字段名称未关联板块名称')
when (isdemandcontent<>'1') 
then concat('采购需求信息的【',isdemandcontent,'】','字段名称未配置完整')

when (issupplyplate<>'1') 
then '供应报价信息未添加任何板块名称。'
when (issupplyfixeddata<>'1') 
then '供应报价信息未添加"固化字段名称服务定价基数或报价失效时间。'
when (noInvalidsupplyplate<>'1') 
then concat('供应报价信息的【',noInvalidsupplyplate,'】','板块名称下没有字段名称')
when (issupplyplatefield<>'1') 
then concat('供应报价信息的【',issupplyplatefield,'】','字段名称未关联板块名称')
when (issupplycontent<>'1') 
then concat('供应报价信息的【',issupplycontent,'】','字段名称未配置完整')
else
''
end as msg
from
(
select 
case when (exists(select 1 from coz_category_supplier_am_model where guid='{bizGuid}' and del_flag='0')) then '1' else '0' end as existscategory
,case when exists(select 1 from coz_category_am_modelprice where biz_guid='{bizGuid}' and del_flag='0' and publish_flag='2') then '0' else '1' end as publishFlag
,case when exists(select 1 from coz_category_am_modelprice where biz_guid='{bizGuid}' and del_flag='0' and price_way='2') then '0' else '1' end as qrcodeFlag

,case when(exists(select 1 from coz_model_am_modelprice_de_plate where biz_guid='{bizGuid}' and del_flag='0')) then '1' else '0' end as isdemandplate
,case when(exists(select 1 from coz_model_am_modelprice_de_plate where biz_guid='{bizGuid}' and del_flag='0' and (fixed_data_code='074dd21c-7050-11ec-89ef-0242ac120003' or fixed_data_code='dbac3896-6cc9-11ec-89ef-0242ac120003'))) then '1' else '0' end as isdemandfixeddata
,ifnull((select alias from coz_model_am_modelprice_de_plate where biz_guid='{bizGuid}' and del_flag='0' and GUID not in(select plate_guid from coz_model_am_modelprice_de_plate_field where biz_guid='{bizGuid}' and del_flag='0')  order by norder limit 1),'1') as noInvaliddemandplate
,ifnull((select alias from coz_model_am_modelprice_de_plate_field where biz_guid='{bizGuid}' and plate_guid ='' and del_flag='0' order by norder limit 1),'1') as isdemandplatefield
,ifnull((select alias from coz_model_am_modelprice_de_plate_field a where a.biz_guid='{bizGuid}' and a.del_flag='0' and (a.content_source='0' or a.operation='0' or ((a.content_source='1' and (a.content_fixed_data_guid is null or a.content_fixed_data_guid=''))) or ((a.content_source='2')  and a.GUID not in(select plate_field_guid from coz_model_am_modelprice_de_plate_field_content where biz_guid='{bizGuid}' and del_flag='0'))) order by a.norder limit 1),'1') as isdemandcontent
,case when(exists(select 1 from coz_model_am_modelprice_sp_plate where biz_guid='{bizGuid}' and del_flag='0')) then '1' else '0' end as issupplyplate
,case when(exists(select 1 from coz_model_am_modelprice_sp_plate_field where biz_guid='{bizGuid}' and del_flag='0' and (name='45738df4-a543-11ec-b8e3-0242ac120002')) and exists(select 1 from coz_model_am_modelprice_sp_plate_field where biz_guid='{bizGuid}' and del_flag='0' and (name='dbac43d0-6cc9-11ec-89ef-0242ac120003'))) then '1' else '0' end as issupplyfixeddata
,ifnull((select alias from coz_model_am_modelprice_sp_plate where biz_guid='{bizGuid}' and del_flag='0' and GUID not in(select plate_guid from coz_model_am_modelprice_sp_plate_field where biz_guid='{bizGuid}' and del_flag='0')  order by norder limit 1),'1') as noInvalidsupplyplate
,ifnull((select alias from coz_model_am_modelprice_sp_plate_field where biz_guid='{bizGuid}' and plate_guid ='' and del_flag='0' order by norder limit 1),'1') as issupplyplatefield
,ifnull((select alias from coz_model_am_modelprice_sp_plate_field a where a.biz_guid='{bizGuid}' and a.del_flag='0' and (a.content_source='0' or a.operation='0' or ((a.content_source='1' and (a.content_fixed_data_guid is null or a.content_fixed_data_guid=''))) or ((a.content_source='2')  and a.GUID not in(select plate_field_guid from coz_model_am_modelprice_sp_plate_field_content where biz_guid='{bizGuid}' and del_flag='0'))) order by a.norder limit 1),'1') as issupplycontent
)t