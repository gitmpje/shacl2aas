INSERT {
  <http://mas4ai.eu/def/WP4/AASEnv> a aas:AssetAdministrationShellEnvironment ;
    aasenv:assetAdministrationShells ?AAS ;
    aasenv:submodels ?Submodel .
}
WHERE {
  ?AAS a aas:AssetAdministrationShell ;
    aasaas:submodel ?Submodel .

  ?Submodel a aas:Submodel .
}