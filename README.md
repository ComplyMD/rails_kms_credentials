# rails-kms-credentials

This gem expands the capabilities of `Rails.application.credentials` to support fetching the credentials from a Key Management System.

## Configuration
This gem will read `config/kms_credentials.yml` using `Rails.application.config_for`.

Key | Description
---|---
`store` | [Stores](#stores) The Key Managedment System to use.

## Stores

Key Management System | Config Value
---|---
[Azure Key Vault](#azure-key-vault) | `azure_key_vault`

### Azure Key Vault
Credentials will be loaded from a Key Vault's Secrets.

All hyphens (`-`) in a secret name will be replaced with underscores (`_`) when put into credentials (ex. `foo-bar` -> `foo_bar`).

Credentials can be nested by separating the parent key from the child key with `--` (ex. secret `foo--bar--baz` with a value of `test` will become `{foo: {bar: {baz: "test"}}}`.

Since Secrets cannot be empty in Azure Key Vault, if you need a key to show up in credentials, but need its value to be empty, then set the Secret's value to `--EMPTY--`.

#### Config
Key | Description
---|---
`vault` | The name of the Key Vault
`client` | Client specific configuration. See [Client Types](#client-types).
`client.type` | The [Client Type](#client-types) to use.
`client.secret_prefix` | The prefix that all secrets for this application will have. See [Secret Prefix](#secret-prefix).

#### Secret Prefix
The prefix along with `----` will be added to the beginning of the secret name (ex. `prefix: abc123` -> `abc123----some-secret`). May be specified with a string, or using your application's name by passing `true` (will use `Rails.application.class.parent.to_s.underscore.dasherize`).


#### Client Types

How to connect/authenticate to Azure Ket Vault.

Client | `client.type`
---|---
[Managed Identity](#managed-identity) | `managed_identity`
[Client Credentials](#client-credentials) | `client_credentials`


##### Managed Identity
This is the client to use when running on an [Azure VM](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-use-vm-token).

**Config:**
Key | Description
---|---
`client.type` | `managed_identity`


##### Client Credentials
This is the client to use when connecting from outside of Azure. [See here](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow).

**Config**
Key | Description
---|---
`client.tenant_id` | The directory tenant the application plans to operate against, in GUID or domain-name format.
`client.client_id` | The application ID that's assigned to your app. You can find this information in the portal where you registered your app.
`client.client_secret` | The client secret that you generated for your app in the app registration portal.
