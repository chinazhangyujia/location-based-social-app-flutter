Mode mode = Mode.DEV;

const String _PROD_SERVICE_DOMAIN =
    'https://location-based-social-app-0.herokuapp.com'; // deployed service on heroku
const String _DEV_SERVICE_DOMAIN =
    'http://localhost:3000'; // local test service

final String SERVICE_DOMAIN =
    mode == Mode.DEV ? _DEV_SERVICE_DOMAIN : _PROD_SERVICE_DOMAIN;
final String WEBSOCKET_DOMAIN = SERVICE_DOMAIN.replaceAll('http', 'ws');

enum Mode { DEV, PRODUCTION }
