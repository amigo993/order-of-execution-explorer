public with sharing class OrderOfExecutionExplorer {
	private Id recordId;

	public OrderOfExecutionExplorer(){//Id recordId
		//this.recordId = recordId;
	}

	public List<String> getOrderOfExecution(){
		List<String> validationRules = this.getValidationRules();
		return validationRules;
	}

	private List<String> getValidationRules(){
		// Define your package version
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();

		// Retrieve the validation rules
		MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
		query.type_x = 'ValidationRule';
		MetadataService.FileProperties[] fileProperties = service.listMetadata(
			new List<MetadataService.ListMetadataQuery> { query }, 60
		);

		// Display the validation rules
		for (MetadataService.FileProperties fileProperty : fileProperties) {
			System.debug('Validation Rule Full Name: ' + fileProperty.fullName);
		}

		return new List<String>();
	}
}