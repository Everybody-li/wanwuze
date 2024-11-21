-- ##Title app-沟通模式-供方(招聘方)-入库人才查找-查询符合条件的需方(应聘方)
-- ##Author lith
-- ##CreateTime 2024-11-18
-- ##Describe
-- ##CallType[QueryData]

-- ##input supplyResumeGuid char[36] NOTNULL;供方入库人才查找条件guid字段
-- ##input sdPathGuid char[36] NOTNULL;品类路径guid
-- ##input page int[>0] NOTNULL;第几页
-- ##input size int[>0] NOTNULL;每页数量
-- ##input curUserId string[36] NOTNULL;登录用户id字段

-- ##output totalCount int[>=0] ;符合的总数量
-- ##output demandResumeGuid char[36] ;需方个人信息入库guid
-- ##output userId char[36] ;需方用户id
-- ##output userName string[20] ;需方用户姓名
-- ##output userImg string[42] ;需方简历图片

-- 创建临时表存储入库人才信息查找中间结果
create temporary table if not exists temp_chat_resume_match1
(
    id                      int      not null auto_increment primary key,
    demand_user_id          char(36) not null,
    demand_resume_guid      char(36) not null,
    sd_path_guid            char(36) not null,
    plate_formal_guid       char(36) not null,
    plate_field_formal_guid char(36) not null,
    max_match_flag          tinyint  not null
);

create temporary table if not exists  temp_chat_resume_match2
(
    id                      int      not null auto_increment primary key,
    demand_user_id          char(36) not null,
    demand_resume_guid      char(36) not null,
    sd_path_guid            char(36) not null,
    plate_formal_guid       char(36) not null,
    plate_field_formal_guid char(36) not null,
    max_match_flag          tinyint  not null
);

delete from temp_chat_resume_match1 where 1=1 ;
delete from temp_chat_resume_match2  where 1=1 ;

-- 向临时表插入中间结果
insert into
    temp_chat_resume_match1( demand_user_id, demand_resume_guid, sd_path_guid, plate_formal_guid, plate_field_formal_guid
                          , max_match_flag )
select
    tt.user_id
    , tt.resume_guid
    , tt.sd_path_guid
  , tt.plate_formal_guid
  , tt.plate_field_formal_guid
  , tt.max_match_flag
from
    (
        select
            t.user_id
          , t.sd_path_guid
          , t.resume_guid
          , t.plate_formal_guid
          , t.plate_field_formal_guid
          , max(t.match_flag) as max_match_flag
        from
            (
                select
                    dt1.user_id
                  , dt1.guid        as resume_guid
                  , dt1.sd_path_guid
                  , dt2.plate_formal_guid
                  , dt2.plate_field_formal_guid
                  , dt2.plate_field_value
                  , IF(exists(select 1
                              from
                                  coz_chat_supply_resume                  st1
                                  inner join coz_chat_supply_resume_plate st2
                                                 on st1.guid = st2.supply_resume_guid
                               inner join coz_model_chat_plate_field_formal ff
                                                 on st2.plate_field_formal_guid = ff.guid
                              where
                                    st1.guid = '{supplyResumeGuid}'
                                and st1.del_flag = '0'
                                and st1.status = '1'
                                and st2.operation in( '1','2')
                                and ff.demand_pf_formal_guid = dt2.plate_field_formal_guid
                                and st2.plate_field_value = dt2.plate_field_value
                           ), 1, 0) as match_flag
                from
                    coz_chat_demand_resume                  dt1
                    inner join coz_chat_demand_resume_plate dt2 on dt1.guid = dt2.demand_resume_guid
                where
                      dt1.del_flag = '0'
                  and dt1.status = '1'
                  and dt2.operation in ('1', '2')
            ) t
        group by t.user_id, t.sd_path_guid, t.resume_guid, t.plate_formal_guid, t.plate_field_formal_guid, t.match_flag
    ) as tt
;

insert into
    temp_chat_resume_match2( demand_user_id, demand_resume_guid, sd_path_guid, plate_formal_guid, plate_field_formal_guid
                          , max_match_flag )
select demand_user_id,demand_resume_guid,sd_path_guid,plate_field_formal_guid,plate_field_formal_guid,max_match_flag from temp_chat_resume_match1;

-- 查询最终结果数量
set @matchCount = 0;
select count(distinct demand_resume_guid)
into @matchCount
from
    temp_chat_resume_match1 t1
where
    not exists(select 1 from temp_chat_resume_match2 t2 where t1.demand_resume_guid = t2.demand_resume_guid and t2.max_match_flag = 0)
;
-- 查询最终结果
select
    tt1.demand_resume_guid as demandResumeGuid
  , tt1.demand_user_id     as userId
  , tt2.user_name   as userName
  , tt3.img         as userImg
  , @matchCount     as totalCount
from
    (
        select sd_path_guid, demand_resume_guid, demand_user_id
        from
            temp_chat_resume_match1 t1
        where
            not exists(select 1
                       from
                           temp_chat_resume_match2 t2
                       where t1.demand_resume_guid = t2.demand_resume_guid and t2.max_match_flag = 0)
        group by sd_path_guid, demand_resume_guid, demand_user_id
    )                           tt1
    inner join sys_app_user     tt2 on tt1.demand_user_id = tt2.guid
    left join  coz_user_biz_img tt3 on tt1.demand_user_id = tt3.user_id
        left join  coz_cattype_sd_path sdp on tt1.sd_path_guid = sdp.guid and sdp.demand_path_guid =  tt3.demand_path_guid
where  (tt3.guid is null or (tt3.guid is not null and tt3.del_flag = '0')) and tt2.del_flag = '0'
order by tt2.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};

