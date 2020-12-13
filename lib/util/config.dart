const String _PROD_SERVICE_DOMAIN = 'https://location-based-social-app.herokuapp.com';
const String _DEV_SERVICE_DOMAIN = 'http://localhost:3000';

final String SERVICE_DOMAIN = _DEV_SERVICE_DOMAIN;
final String WEBSOCKET_DOMAIN = SERVICE_DOMAIN.replaceAll('http', 'ws');