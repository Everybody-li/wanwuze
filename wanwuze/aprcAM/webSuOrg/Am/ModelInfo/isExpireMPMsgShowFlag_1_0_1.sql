-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-编辑型号-打开编辑型号弹窗前判断型号是否失效(标红)
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 出参”expireMPMsgShowFlag“逻辑：t1.status=0，则返回是，否则返回否，且弹窗内容：expireMPMsg的值：该品类的型号交易信息有变动，请及时更正，不然影响采购需求接收
-- ##Describe 表名:coz_category_supplier_am_model_plate t1
-- ##CallType[QueryData]

-- ##input modelGuid char[36] NOTNULL;型号guid,必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output expireMPMsgShowFlag enum[0,1] 1;型号名称的交易信息变更提示窗：0-不弹窗，1-弹窗
-- ##output expireMPMsg string[100] 型号名称的交易信息变更提示窗内容;该品类的型号交易信息有变动，请及时更正，不然影响采购需求接收

select
t.*
,case when (t.expireMPMsgShowFlag='1') then '该品类的型号交易信息有变动，请及时更正，不然影响采购需求接收。' else '' end as expireMPMsg
from
( 
select
case when exists(select 1 from coz_category_supplier_am_model_plate where status='0' and model_guid='{modelGuid}' and del_flag='0') then '1' else '0' end as expireMPMsgShowFlag
)t
