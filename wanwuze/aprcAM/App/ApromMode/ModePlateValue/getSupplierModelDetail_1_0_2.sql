-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-供方信息-查询供方详情
-- ##Author 卢文彪
-- ##CreateTime 2023-08-02
-- ##Describe 查询：出参”qrCode“取t3的id最大的那条
-- ##Describe 表名：coz_category_supplier_am_model t1, coz_category_supplier_am_model_price_plate t2,coz_category_am_modelprice_log t3,coz_org_info
-- ##CallType[QueryData]

-- ##input modelGuid char[36] NOTNULL;型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output supplyCompanyName string[200] 供应主体;
-- ##output modelGuid char[36] 型号guid;
-- ##output modelName string[50] 品类供方型号名称;
-- ##output priceWay enum[0,1] 品类供方型号报价方式：1-非二维码，2-二维码;
-- ##output qrCode string[200] 二维码图片地址(后端相对路径);
-- ##output qrcodeUrl string[500] 二维码的url;
-- ##output invalidQrcodeMsg string[500] 二维码识别错误提示语;二维码识别错误提示语（前端：二维码URL为空时弹窗提示，后端：内容返回：识别没有成功，用微信扫一扫试一下）
-- ##output plates.plateGuid char[36] 板块名称guid;
-- ##output plates.plateAlias string[20] 板块名称别名;
-- ##output plates.plateNorder int[>0] 板块名称排序;
-- ##output plates.fields.plateFieldGuid char[36] 字段名称guid;
-- ##output plates.fields.plateFieldAlias string[50] 字段名称别名;
-- ##output plates.fields.plateFieldNorder int[>0] 字段名称排序;
-- ##output plates.fields.plateFieldOperation enum[1,2,3,4,5] 字段名称操作设置：1-单选框(需要额外请求接口获取字段内容数据)，2-复选框(需要额外请求接口获取字段内容数据)，3-填写文本框，4-图片上传，5-文档上传;
-- ##output plates.fields.values.value string[200] 供方填写的字段内容值;


set @priceWay = '';
set @qrCode = '';
set @qrcodeUrl = '';

# 查已发布的最大的一条
select price_way, qrcode, qrcode_url
into @priceWay,@qrCode,@qrcodeUrl
from coz_category_am_modelprice_log
where biz_guid = '{modelGuid}'
  and del_flag = '0'
order by id desc
limit 1;

select t3.name                                                                 as supplyCompanyName
     , t.guid                                                                  as modelGuid
     , t.name                                                                  as modelName
     , @priceWay                                                               as priceWay
     , concat('ARPC/WEB/AM/MODELPRICE/QRCODE/', left(@qrCode, 1), '/', @qrCode) as qrCode
     , @qrcodeUrl                                                         as qrcodeUrl
     , '识别没有成功，用微信扫一扫试一下'                                       as invalidQrcodeMsg
     , CONCAT('{ChildRows_aprcAM\\App\\ApromMode\\ModePlateValue\\getSupplierModelPlates_1_0_1:modelGuid='''
    , t.guid
    , '''}')                                                                   as `plates`
from coz_category_supplier_am_model t
         inner join coz_category_supplier t2
                    on t.supplier_guid = t2.guid
         inner join coz_org_info t3 on t2.user_id = t3.user_id
where t.guid = '{modelGuid}'
  and t.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0';