public class httpSetup {
    public static HttpResponse Setup(String requestToken, String inputJSON){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');
        request.setHeader('token',requestToken);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(inputJSON);
        HttpResponse response = http.send(request);
        return response;
    }
    
}