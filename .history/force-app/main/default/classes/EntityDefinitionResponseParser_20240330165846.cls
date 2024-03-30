public with sharing class EntityDefinitionResponseParser {
    
	public EntityDefinitionWrapper parse(HttpResponse response) {
		String body = response.getBody();
		Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(body);
		System.debug(responseMap);
		List<Object> rawEntityDefinitions = (List<Object>) responseMap.get('records');
		Map<String, Object> rawEntityDefinitionMap = (Map<String, Object>) rawEntityDefinitions.get(0);
		EntityDefinitionWrapper entityDefinitionWrapper = new EntityDefinitionWrapper();
		entityDefinitionWrapper.durableId = String.valueOf(rawEntityDefinitionMap.get('DurableId'));

		Map<String, Object> rawValidationRulesContainer = (Map<String, Object>) rawEntityDefinitionMap.get('ValidationRules');
		List<Object> rawValidationRules = (List<Object>) rawValidationRulesContainer.get('records');

		List<ValidationRuleWrapper> validationRuleWrappers = new List<ValidationRuleWrapper>();
		for (Object rawValidationRule : rawValidationRules) {
			Map<String, Object> rawValidationRuleMap = (Map<String, Object>) rawValidationRule;
			ValidationRuleWrapper validationRuleWrapper = new validationRuleWrapper();
			validationRuleWrapper.validationName = String.valueOf(rawValidationRuleMap.get('ValidationName'));
			validationRuleWrappers.add(validationRuleWrapper);
		}

		entityDefinitionWrapper.validationRuleWrappers = validationRuleWrappers;
		System.debug(entityDefinitionWrapper);

		return entityDefinitionWrapper;
	}
}