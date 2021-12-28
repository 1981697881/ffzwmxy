class API {
  /*static const String API_PREFIX = 'http://192.168.31.211/K3Cloud';
  static const String ACCT_ID = '614c1ba7c39b80';*/
  static const String API_PREFIX = 'http://61.146.130.53:50252/K3Cloud';
  static const String ACCT_ID = '5fe490b0e085f3';
  static const String lcid = '2052';
  static const String LOGIN_URL = API_PREFIX + '/Kingdee.BOS.WebApi.ServicesStub.AuthService.ValidateUser.common.kdsvc';
  //通用查询
  static const String CURRENCY_URL = API_PREFIX + '/Kingdee.BOS.WebApi.ServicesStub.DynamicFormService.ExecuteBillQuery.common.kdsvc';
  //单据提交
  static const String SUBMIT_URL = API_PREFIX + '/Kingdee.BOS.WebApi.ServicesStub.DynamicFormService.Save.common.kdsvc';
  //下推
  static const String DOWN_URL = API_PREFIX + '/Kingdee.BOS.WebApi.ServicesStub.DynamicFormService.Push.common.kdsvc';
  //修改状态
  static const String STATUS_URL = API_PREFIX + '/Kingdee.BOS.WebApi.ServicesStub.DynamicFormService.ExcuteOperation.common.kdsvc';
}
