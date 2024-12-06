-- ##Title web后台-审批报价配置管理-xx供应路径-供应审批报价管理-品类审批报价管理-型号报价方式设置-修改
-- ##Author lith
-- ##CreateTime 2023-08-04
-- ##Describe 新增或修改
-- ##Describe coz_category_am_modelprice t2
-- ##CallType[ExSql]

-- ##input bizGuid char[36] NOTNULL;型号guid
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid
-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input priceWay enum[1,2] NOTNULL;型号报价方式：1-非二维码，2-二维码
-- ##input qrcode string[42] NULL;二维码图片：型号报价方式为2时必填，目录：ARPC/WEB/AM/MODELPRICE/QRCODE/{二维码图片名称guid首字母}/
-- ##input qrcodeUrl string[500] NULL;二维码url
-- ##input curUserId char[36] NOTNULL;当前登录用户id


set @flag1=(select case when exists(select 1 from coz_category_am_modelprice where biz_guid='{bizGuid}' and del_flag='0') then '1' else '0' end)
;

update coz_category_am_modelprice
set price_way='{priceWay}'
,qrcode='{qrcode}'
,qrcode_url='{qrcodeUrl}'
,publish_flag='0'
where biz_guid='{bizGuid}' and @flag1='1'
;

insert into coz_category_am_modelprice
(
biz_guid
,cattype_guid
,category_guid
,price_way
,qrcode
,qrcode_url
,del_flag
,create_by
,create_time
)
select
'{bizGuid}' as guid
,'{cattypeGuid}' as cattype_guid
,'{categoryGuid}' as category_guid
,'{priceWay}' as priceWay
,'{qrcode}' as qrcode
,'{qrcodeUrl}'as qrcodeUrl
,0 as del_flag
,'-1' as create_by
,now() as create_time
where 
@flag1='0'
;

{file[aprcAM\Web\Suprice\Cattype\Price\updPublishFlag2UnPub_1_0_1.sql]/file}
