public with sharing class OrderOfExecutionController {

	@AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getOrderOfExecution(String recordId) {
        OrderOfExecutionExplorer explorer = new OrderOfExecutionExplorer(Id.valueOf(recordId));
        return explorer.getOrderOfExecution();
    }
}