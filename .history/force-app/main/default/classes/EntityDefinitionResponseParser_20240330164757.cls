public with sharing class EntityDefinitionResponseParser {
    
	public EntityDefinitionWrapper parse(HttpResponse response) {
		String body = response.getBody();
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(body);
		System.debug(responseMap);
		Map<String, Object> rawEntityDefinitionsMap = (Map<String, Object>)responseMap.get('records').get(0);
		// List<EntityDefinitionWrapper> entityDefinitionWrappers = (List<EntityDefinitionWrapper>)rawEntityDefinitions;
		System.debug(rawEntityDefinitionsMap);

		return new EntityDefinitionWrapper();
	}
}