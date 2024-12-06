-- ##Title web后台-审批模式-通用配置-供应报价信息管理-发布(品类类型调用)
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 发布品类的供应报价信息
-- ##Describe
-- ##Describe 1、调用接口：aprcAM\PluginServe\Suprice\Cattype\Price\isCanPublish_1_0_1 判断是否可以发布，如果不可以，则将接口提示语写入缓存，停止逻辑处理;若返回可以，则向缓存写入提示语："{品类名称}否符合发布要求，正在发布"，继续
-- ##Describe 2、调用接口：aprcAM\PluginServe\Suprice\Cattype\Price\publish_1_0_1 进行发布。若接口返回失败，向缓存写入：提示语："{品类名称}"+该接口的返回提示"，doneFlag=1，停止逻辑处理;若返回成功(向缓存写入提示语："{品类名称}"+发布已完成，正在检查是否影响供方型号内容")，则继续
-- ##CallType[Plugin_Text]


-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果：0-失败，1-成功
-- ##output msg string[100] 操作提示语;操作提示语
