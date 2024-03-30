public with sharing class EntityDefinitionResponseParser {
    
	public EntityDefinitionWrapper parse(HttpResponse response) {
		String body = response.getBody();
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(body);
		Map<String, Object> rawEntityDefinitionsMap = (Map<String, Object>)responseMap.get('records');
		// List<EntityDefinitionWrapper> entityDefinitionWrappers = (List<EntityDefinitionWrapper>)rawEntityDefinitions;
		System.debug(entityDefinitionWrappers);

		return new EntityDefinitionWrapper();
	}
}