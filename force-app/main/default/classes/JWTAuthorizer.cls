public with sharing class JWTAuthorizer {

	public String getAccessToken(){
		Auth.JWT jwt = new Auth.JWT();
		JWT__mdt jwtAuthInfo = JWT__mdt.getInstance('Auth_Info');
        jwt.setSub(jwtAuthInfo.Username__c);
        jwt.setAud('https://test.salesforce.com');
        jwt.setIss(jwtAuthInfo.Consumer_Key__c);
		//Create the object that signs the JWT bearer token
		Auth.JWS jws = new Auth.JWS(jwt, jwtAuthInfo.Certificate_Name__c);
        //Additional claims to set scope
        // Map<String, Object> claims = new Map<String, Object>();
        // claims.put('scope', 'scope name');
        // jwt.setAdditionalClaims(claims);


        //Get the resulting JWS in case debugging is required
        // String token = jws.getCompactSerialization();
        //Set the token endpoint that the JWT bearer token is posted to
        String tokenEndpoint = 'https://test.salesforce.com/services/oauth2/token';
        //POST the JWT bearer token
        Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(tokenEndpoint, jws);
        //Get the access token
        String accessToken = bearer.getAccessToken();

		return accessToken;
	}
}