OrderOfExecutionExplorer explorer = new OrderOfExecutionExplorer(Id.valueOf('a001m0000040sQ3AAI'));
explorer.getOrderOfExecution();

// String queryUrl =
// 			'callout:Tooling_API_Credential/services/data/v59.0/tooling/query?q=SELECT+Metadata+FROM+Flow+LIMIT+1';

// String toolingApiUrl = 'callout:Tooling_API_Credential/services/data/v59.0/tooling/query?q=';
// String objectApiName = 'Order_Of_Execution_Test__c';
// String query = 'SELECT FullName FROM Flow WHERE Metadata.Status = \'Active\' AND Metadata.Start.Object = \'' + objectApiName + '\' LIMIT 1';

// HttpRequest request = new HttpRequest();
// request.setEndpoint(toolingApiUrl + EncodingUtil.urlEncode(query, 'UTF-8'));
// request.setMethod('GET');

// Http http = new Http();
// HttpResponse response = http.send(request);
// System.debug(response.getBody());