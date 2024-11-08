-- ##Title web-供应-查询成果交接管理菜单是否有红点
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应-查询成果交接管理菜单是否有红点
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;供方用户id，必填

select 
case 
when exists(select 1 from coz_order t where t.sd_path_guid='{sdPathGuid}' and t.supply_user_id= '{curUserId}' and t.supply_done_flag='0' and t.del_flag='0' and t.pay_status= '2' and t.accept_status='0' and t.supply_read_flag='0' and not exists(select 1 from coz_order_cancel where order_guid=t.guid and del_flag='0'  and cancel_object='2') and (not exists(select 1 from coz_order_judge where order_guid=t.guid and del_flag='0') or exists(select 1 from coz_order_judge where (result='3' or supply_read_flag='0') and order_guid=t.guid and del_flag='0') ))
then
'1'
else
'0'
end as hasRedPointFlag
