@isTest
public class BillingCalloutServiceMock implements WebServiceMock {
    public void doInvoke(Object stub, Object soapRequest, Map<String,Object> responseMap, String endpoint, String soapAction, String requestName, String responseNamespace, String responseName, String responseType){
        BillingServiceProxy.billProjectResponse_element proxyResponse = new BillingServiceProxy.billProjectResponse_element();
        proxyResponse.status = 'OK';
        responseMap.put('response_x', proxyResponse);
    }
}