public with sharing class EntityDefinitionResponseParser {
    
	public EntityDefinitionWrapper parse(HttpResponse response) {
		String body = response.getBody();
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(body);
		Object rawEntityDefinitions = responseMap.get('records');
		System.debug(rawEntityDefinitions);
	}
}