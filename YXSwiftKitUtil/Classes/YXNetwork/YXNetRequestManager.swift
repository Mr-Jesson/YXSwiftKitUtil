//
//  YXNetRequestManager.swift
//  YXSwiftKitUtil
//
//  Created by Mr_Jesson on 2022/3/8.
//

import UIKit
import Moya
import RxSwift
import ObjectMapper
import SwiftyJSON

private func JSONResponseDataFormatter(_ data: Data) -> String {
  do {
    let dataAsJSON = try JSONSerialization.jsonObject(with: data)
    let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
    return String(data: prettyData, encoding: .utf8) ?? ""
  } catch {
    if JSONSerialization.isValidJSONObject(data) {
        return String(data: data, encoding: .utf8) ?? ""
    }
    return ""
  }
}

private let myEndpointClosure = {(target:TargetType) -> Endpoint in
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    var endpoint = Endpoint(url: url, sampleResponseClosure: {
        .networkResponse(200, target.sampleData)
    }, method: target.method, task: task, httpHeaderFields: target.headers)
    
    return endpoint
}

//网络请求设置
private let requestClosure = {(endpoint:Endpoint,done:MoyaProvider.RequestResultClosure) in
    do{
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 30
        if let requestData = request.httpBody {
            let requestMsg = "😄😄😄Request URL😄😄😄\n\(request.url!)" + "\n" + "\(request.httpMethod ?? "")" + "😄😄😄Request Body😄😄😄\n" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")"
            YXKitLogger.printLog(log: requestMsg, logType: .debug)
        }else{
            YXKitLogger.printLog(log: "😄😄😄Request URL😄😄😄\n\(request.url!)" + "\n" + "\(String(describing: request.httpMethod))", logType: .debug)
        }
        if let header = request.allHTTPHeaderFields {
            YXKitLogger.printLog(log: "😄😄😄Request Header😄😄😄\n\(header)", logType: .debug)
        }
        done(.success(request))
    } catch{
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

private let networkPlugin = NetworkActivityPlugin.init { changeType, _ in
    print("networkPlugin \(changeType)")
    switch changeType{
    case .began:
        YXKitLogger.printLog(log: "😄😄😄Request Start😄😄😄", logType: .debug)
    case .ended:
        YXKitLogger.printLog(log: "😄😄😄Request End😄😄😄", logType: .debug)
    }
}

public typealias YXRequestProgressBlock = (_ progress: ProgressResponse) -> Void

public typealias YXRequestSuccessBlock = (_ responseModel: YXResponseModel) -> Void

public typealias YXRequestFailBlock = (_ responseModel: YXResponseModel) -> Void

open class YXNetRequestManager {
    
    public static let manager = YXNetRequestManager();
    
    private init(){}
    
    private var codeKey:String = "";
    private var messageKey:String = "";
    private var retDataKey:String = "";
    private var successCode:String = "1"
    
    
    /// 对当前网络请求进行配置
    /// - Parameters:
    ///   - codeKey: 返回数据的code码
    ///   - messageKey: 返回数据的message
    ///   - successCode: 返回数据表示成功的code值
    ///   - retDataKey: 返回数据对应的数据key值
    public func configNetRequst(codeKey:String = "code",messageKey:String = "message",successCode:String = "1",retDataKey:String = "retData"){
        self.codeKey = codeKey;
        self.messageKey = messageKey;
        self.retDataKey = retDataKey;
        self.successCode = successCode;
    }
    
    let configuration = NetworkLoggerPlugin.Configuration(
        formatter: NetworkLoggerPlugin.Configuration.Formatter(
            requestData: JSONResponseDataFormatter,
            responseData: JSONResponseDataFormatter
        ),
        logOptions: .verbose
    )
    ///返回数据格式是字典对象
    public func request<T: Mappable>(target:TargetType,modelType: T.Type,callbackQueue:DispatchQueue? = nil,progressCallback:YXRequestProgressBlock? = nil,successCallback:YXRequestSuccessBlock? = nil,failCallback:YXRequestFailBlock? = nil){
        let provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)
        provider.request(MultiTarget(target), callbackQueue: callbackQueue) { progress in
            progressCallback?(progress);
        } completion: { result in
            switch result {
            case let .success(response):
                do{
                    let jsonData = try JSON(data:response.data);
                    let responseModel:YXResponseModel = YXResponseModel();
                    responseModel.code = jsonData[self.codeKey].rawString() ?? "501";
                    responseModel.message = jsonData[self.messageKey].stringValue;
                    if responseModel.code == self.successCode {//成功的请求
                        //对数据进行解析
                        if let model = T(JSONString: jsonData[self.retDataKey].rawString() ?? "") {
                            responseModel.data = model as AnyObject;
                        }else{
                            responseModel.data = jsonData[self.retDataKey] as AnyObject
                        }
                    }else{//请求失败，需要进行相关处理
                        
                    }
                    successCallback?(responseModel);
                }catch{
                    let responseModel:YXResponseModel = YXResponseModel();
                    responseModel.code = "500";
                    responseModel.message = "return data not json";
                    failCallback?(responseModel);
                }
            case let .failure(error):
                guard let errorDes = error.errorDescription else{
                    break
                }
                let responseModel:YXResponseModel = YXResponseModel();
                responseModel.code = "404";
                responseModel.message = errorDes;
                failCallback?(responseModel);
            }
        }
    }
    
    ///返回列表数据
    public func requestList<T: Mappable>(target:TargetType,modelType: [T].Type,callbackQueue:DispatchQueue? = nil,progressCallback:YXRequestProgressBlock? = nil,successCallback:YXRequestSuccessBlock? = nil,failCallback:YXRequestFailBlock? = nil){
        let provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)
        provider.request(MultiTarget(target), callbackQueue: callbackQueue) { progress in
            progressCallback?(progress);
        } completion: { result in
            switch result {
            case let .success(response):
                do{
                    let jsonData = try JSON(data:response.data);
                    let responseModel:YXResponseModel = YXResponseModel();
                    responseModel.code = jsonData[self.codeKey].rawString() ?? "501";
                    responseModel.message = jsonData[self.messageKey].stringValue;
                    if responseModel.code == self.successCode {//成功的请求
                        //对数据进行解析
                        if let model = [T](JSONString: jsonData[self.retDataKey].rawString() ?? "") {
                            responseModel.data = model as AnyObject;
                        }else{
                            responseModel.data = jsonData[self.retDataKey] as AnyObject
                        }
                    }else{//请求失败，需要进行相关处理
                        
                    }
                    successCallback?(responseModel);
                }catch{
                    let responseModel:YXResponseModel = YXResponseModel();
                    responseModel.code = "500";
                    responseModel.message = "return data not json";
                    failCallback?(responseModel);
                }
            case let .failure(error):
                guard let errorDes = error.errorDescription else{
                    break
                }
                let responseModel:YXResponseModel = YXResponseModel();
                responseModel.code = "404";
                responseModel.message = errorDes;
                failCallback?(responseModel);
            }
        }
    }
}

public class YXResponseModel {
    var code: String = "000000"
    var message: String = ""
    var data: AnyObject?
}
