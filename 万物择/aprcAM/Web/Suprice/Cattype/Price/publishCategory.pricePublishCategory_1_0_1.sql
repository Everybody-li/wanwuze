-- ##Title web后台-审批模式-通用配置-供应报价信息管理-发布(品类名称调用)
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 发布品类的供应报价信息
-- ##Describe 整体步骤：1、判断品类是否可以发布 2、执行发布 3、品类配置重新发发布后，检查供方已经设置型号内容的是否受到影响，收到影响的要向供方标记配置变更提示
-- ##Describe
-- ##Describe 1、调用接口：aprcAM\PluginServe\Suprice\Cattype\Price\isCanPublish_1_0_1 判断是否可以发布，如果不可以，则返回接口提示语，停止逻辑处理;若返回可以，则继续
-- ##Describe 2、调用接口：aprcAM\PluginServe\Suprice\Cattype\Price\publish_1_0_1 进行发布。若接口返回失败，则返回该接口的提示语，停止逻辑处理;若返回成功(成功也有成功的提示语)，当前接口返回，并开启异步线程继续处理后续步骤(3、4、5、6)
-- ##Describe 3、调用接口(异步线程处理)：aprcAM\PluginServe\Suprice\Cattype\Price\getSupplierList_1_0_1 查找当前品类供方列表，若返回数据为空，则返回接口2的提示语，并停止逻辑处理;若返回供方数据，则继续
-- ##Describe 4、调用接口(异步线程处理)：aprcAM\PluginServe\Suprice\Cattype\Price\getPlFieldFormalList_1_0_1,aprcAM\PluginServe\Suprice\Cattype\Price\getPlFieldContFormalList_1_0_1 查询当前品类已发布的全部字段内容列表，若返回数据为空,则打印日志：提示语："当前{品类名称}已发布供应报价信息，但是处理供方型号交易信息变更配置异常：字段内容未查询到，请检查是否正确配置！”并停止逻辑处理。若有返回数据，则继续
-- ##Describe 5、调用接口(异步线程处理)：将步骤3的供方列表进行循环处理，逐一调用接口：aprcAM\PluginServe\Suprice\Cattype\Price\getSupplierModelList_1_0_1,aprcAM\PluginServe\Suprice\Cattype\Mode\getModelPlFieldList_1_0_1,aprcAM\PluginServe\Suprice\Cattype\Price\getModelPlFieldContList_1_0_1 获取供方填写的的自建库的字段内容值，如果数据返回为空，则继续步骤5查询下一个供方，支持循环完毕，若循环完毕也未查到，则打印日志：品类的供应报价信息没有供方添加型号产品介绍，停止逻辑处理并返回步骤2的接口提示语
-- ##Describe   5.1、若返回数据不为空，则按型号分组循环处理
-- ##Describe   5.2、将数据与步骤4的数据逐一比对，
-- ##Describe   5.2.1、若型号有字段名称guid在品类的字段名称guid集合中不存在，
-- ##Describe   5.2.2、或字段名称的操作设置是单选或者多选,
-- ##Describe   5.2.2.1、字段内容来源是固化库的情况下,字段内容固化库code不相等
-- ##Describe   5.2.2.2、字段内容来源是自建库的情况下,字段内容值在品类的对应字段名称下的字段内容集合中不存在
-- ##Describe   5.2.3、满足5.2.1.1或5.2.2.2任一条件,则将该型号的字段名称guid标记为失效,循环处理供方所有的型号字段及内容数据.直至型号循环处理完毕。共有3个嵌套循环：第一层：循环供方型号列表，第二层：循环供方的字段名称guid列表，第三层：循环供方的字段名称下的字段内容值列表
-- ##Describe 6、(异步线程处理)将步骤5.2标记的失效数据作为入参调用接口：aprcAM\PluginServe\Suprice\Cattype\Price\updSupplierStatus0_1_0_1，若接口返回失败，则打印日志：品类发布成功，但是处理供方型号交易信息变更配置标记红色色块警示异常，请联系管理员！"，否则打印日志：品类发布供应报价信息成功，处理供方型号交易信息变更配置标记红色色块警示成功！
-- ##CallType[Plugin_Text]


-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果：0-失败，1-成功
-- ##output msg string[100] 操作提示语;操作提示语
