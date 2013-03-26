# app_name Server API #
 * host-production: `http://app_name.2359media.net`
 * host-staging: `http://app_name-staging.2359media.net`
 * global_params: `abc`, `xyz`

## Module Heading ##
### Submodule Heading ###
 * URL: `api/v1/`
 * method: `GET`
 * params: `some`, `parameters`, `here` 
 * response:

(failure)
```javascript
{
    "key": "some",
    "another_key": [1, 2, 3],
}
```

(success)
```javascript
{
    "key": "some",
    "another_key": [1, 2, 3],
}
```



--------------------------
## NOTE ##
Status codes:

  * `AUTH_MISSING` = 101
  * `AUTH_INVALID` = 102
  * `PARAMS_MISSING` = 201
  * `PARAMS_INVALID` = 202
  * `ACCESS_DENIED` = 301
  * `ENTITY_NOT_FOUND` = 401
  * `REMOTE_DENIED` = 501
  * `REMOTE_BROKEN_PIPE` = 502