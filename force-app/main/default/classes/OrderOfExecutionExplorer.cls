public with sharing class OrderOfExecutionExplorer {
	private Id recordId;
	private String objectApiName;
	private	String durableId;
	private String developerName;
	// EntityDefinition objectDefinition;

	public OrderOfExecutionExplorer(Id recordId){
		this.recordId = recordId;
		this.objectApiName = String.valueOf(recordId.getSobjectType());
		this.developerName = this.objectApiName.removeEnd('__c');
		EntityDefinition objectDefinition = [
			SELECT DurableId, DeveloperName
			FROM EntityDefinition
			WHERE DeveloperName = :this.developerName
			LIMIT 1
		];
		System.debug(objectDefinition);
		this.durableId = objectDefinition.DurableId;
	}

	public List<String> getOrderOfExecution(){
		List<String> validationRules = this.getValidationRulesTooling();
		return validationRules;
	}

	private List<String> getValidationRulesTooling(){
		String queryUrl =
			'callout:Tooling_API_Credential/services/data/v59.0/tooling/query?q=SELECT+DurableId,QualifiedApiName,(SELECT+ValidationName+FROM+ValidationRules+WHERE+Active=TRUE)+FROM+EntityDefinition+WHERE+DeveloperName=\''+ this.developerName + '\'';

		HttpRequest request = new HttpRequest();
		request.setEndpoint(queryUrl);
		request.setMethod('GET');

		Http http = new Http();
		HttpResponse response = http.send(request);

		EntityDefinitionWrapper entityDefinitionWrapper;
		if (response.getStatusCode() == 200) {
			EntityDefinitionResponseParser parser = new EntityDefinitionResponseParser();
			entityDefinitionWrapper = parser.parse(response);
			System.debug(entityDefinitionWrapper);
		} else {
			System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
			System.debug(response);
		}

		List<String> orderOfExecutionItems = new List<String>();
		for (ValidationRuleWrapper validationRuleWrapper : entityDefinitionWrapper.validationRuleWrappers) {
			orderOfExecutionItems.add(validationRuleWrapper.validationName);
		}
		return orderOfExecutionItems;
	}

	private List<String> getValidationRulesMetadataApi(){
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();

		MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
		query.type_x = 'ValidationRule';
		query.folder = this.objectApiName;
		MetadataService.FileProperties[] fileProperties = service.listMetadata(
			new List<MetadataService.ListMetadataQuery> { query }, 59
		);

		for (MetadataService.FileProperties fileProperty : fileProperties) {
			System.debug('Validation Rule Full Name: ' + fileProperty.fullName);
		}

		return new List<String>();
	}
}