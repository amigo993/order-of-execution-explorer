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
		// System.debug(objectDefinition);
		this.durableId = objectDefinition.DurableId;
	}

	public Map<String, List<String>> getOrderOfExecution(){
		Map<String, List<String>> orderOfExecutionItemsMap = new Map<String, List<String>>{
			'Validation Rules' => this.getValidationRulesTooling(),
			'Flows' => this.getFlows(),
			'Before Triggers' => this.getBeforeTriggers(),
			'Duplicate Rules' => this.getDuplicateRules()
		};
		return orderOfExecutionItemsMap;
	}

	private List<String> getDuplicateRules(){
		List<DuplicateRule> duplicateRules = [
			SELECT MasterLabel
			FROM DuplicateRule
			WHERE IsActive = TRUE
				AND SobjectType = :this.objectApiName
		];

		List<String> duplicateRuleNames = new List<String>();
		for (DuplicateRule duplicateRule : duplicateRules) {
			duplicateRuleNames.add(duplicateRule.MasterLabel);
		}
		return duplicateRuleNames;
	}

	private List<String> getBeforeTriggers(){
		List<ApexTrigger> triggers = [
			SELECT Name
			FROM ApexTrigger
			WHERE TableEnumOrId = :this.objectApiName
				AND Status = 'Active'
				AND (UsageBeforeInsert = TRUE OR UsageBeforeUpdate = TRUE)
		];
		List<String> triggerNames = new List<String>();
		for (ApexTrigger triggerRecord : triggers) {
			triggerNames.add(triggerRecord.Name);
		}
		return triggerNames;
	}

	private List<String> getValidationRulesTooling(){
		// String namedCredentialsUrl = 'callout:Tooling_API_Credential/services/data/v59.0/tooling/query?q=';
		String nonNamedCredentialsUrl = URL.getOrgDomainUrl().toExternalForm() + '/services/data/v59.0/tooling/query?q=';
		String query = 'SELECT DurableId,QualifiedApiName,(SELECT ValidationName FROM ValidationRules WHERE Active=TRUE) FROM EntityDefinition WHERE DeveloperName=\''+ this.developerName + '\'';

		HttpRequest request = new HttpRequest();
		// request.setEndpoint(namedCredentialsUrl + EncodingUtil.urlEncode(query, 'UTF-8'));
		request.setEndpoint(nonNamedCredentialsUrl + EncodingUtil.urlEncode(query, 'UTF-8'));
		request.setMethod('GET');

		//either this ot namedCredentialsUrl to get the access token
		JWTAuthorizer authorizer = new JWTAuthorizer();
		String accessToken = authorizer.getAccessToken();
		request.setHeader('Authorization', 'Bearer ' + accessToken);

		Http http = new Http();
		HttpResponse response = http.send(request);

		EntityDefinitionWrapper entityDefinitionWrapper;
		if (response.getStatusCode() == 200) {
			EntityDefinitionResponseParser parser = new EntityDefinitionResponseParser();
			entityDefinitionWrapper = parser.parse(response);
		} else {
			System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
			System.debug(response);
		}

		List<String> validationRuleNames = new List<String>();
		for (ValidationRuleWrapper validationRuleWrapper : entityDefinitionWrapper.validationRuleWrappers) {
			validationRuleNames.add(validationRuleWrapper.validationName);
		}
		return validationRuleNames;
	}

	private List<String> getFlows(){
		List<FlowDefinitionView> flows = [
			SELECT Label
			FROM FlowDefinitionView
			WHERE TriggerType IN ('RecordAfterSave', 'RecordBeforeSave')
				AND TriggerObjectOrEventId = :this.durableId
		];

		List<String> flowLabels = new List<String>();
		for (FlowDefinitionView flow : flows) {
			flowLabels.add(flow.Label);
		}
		return flowLabels;
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