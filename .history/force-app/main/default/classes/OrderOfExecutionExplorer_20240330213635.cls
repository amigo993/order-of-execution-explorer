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
		// Construct the Tooling API Query URL
		String queryUrl =
			'/services/data/60.0/tooling/query?q=SELECT+DurableId,QualifiedApiName,(SELECT+ValidationName+FROM+ValidationRules+WHERE+Active=TRUE)+FROM+EntityDefinition+WHERE+DeveloperName=\''+ this.developerName + '\'';

		// Create the HTTP request
		HttpRequest request = new HttpRequest();
		request.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + queryUrl);
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());

		// Send the request
		Http http = new Http();
		HttpResponse response = http.send(request);

		EntityDefinitionWrapper entityDefinitionWrapper;
		// Process the response
		if (response.getStatusCode() == 200) {
			EntityDefinitionResponseParser parser = new EntityDefinitionResponseParser();
			entityDefinitionWrapper = parser.parse(response);
			System.debug(entityDefinitionWrapper);
			// System.debug(JSON.deserializeUntyped(response.getBody()));
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
		// Define your package version
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();

		// Retrieve the validation rules
		MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
		query.type_x = 'ValidationRule';
		query.folder = this.objectApiName;
		MetadataService.FileProperties[] fileProperties = service.listMetadata(
			new List<MetadataService.ListMetadataQuery> { query }, 59
		);

		// Display the validation rules
		for (MetadataService.FileProperties fileProperty : fileProperties) {
			System.debug('Validation Rule Full Name: ' + fileProperty.fullName);
		}

		return new List<String>();
	}
}