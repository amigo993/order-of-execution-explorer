public with sharing class EntityDefinitionResponseParser {
    
	public EntityDefinitionWrapper parse(HttpResponse response) {
		String body = response.getBody();
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(body);
		System.debug(responseMap);
		List<Object> rawEntityDefinitions = (List<Object>)responseMap.get('records');
		Map<String, Object> rawEntityDefinitionMap = (Map<String, Object>)rawEntityDefinitions.get(0);
		// List<EntityDefinitionWrapper> entityDefinitionWrappers = (List<EntityDefinitionWrapper>)rawEntityDefinitionMap;
		System.debug(rawEntityDefinitionMap);

		return new EntityDefinitionWrapper();
	}
}