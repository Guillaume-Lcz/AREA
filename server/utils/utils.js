import queryString from 'query-string';

const getTokenParams = (app, code, isMobile) =>
  queryString.stringify({
    client_id: app.client_id,
    client_secret: app.client_secret,
    code,
    grant_type: 'authorization_code',
    redirect_uri: isMobile ? app.redirect_mobile : app.redirect_url,
  });


export { getTokenParams };

