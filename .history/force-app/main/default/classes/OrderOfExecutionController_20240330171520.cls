public with sharing class OrderOfExecutionController {

	@AuraEnabled
    public static List<String> getOrderOfExecutionFor(String recordId) {
        OrderOfExecutionExplorer explorer = new OrderOfExecutionExplorer(Id.valueOf(recordId));
        return explorer.getOrderOfExecution();
    }
}