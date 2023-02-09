INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?AAS aasaas:submodels [
      a aas:Reference ;
      aasref:type aasreft:ModelReference ;
      aasref:keys [
        a aas:Key ;
        aaskey:type aaskeyt:Submodel ;
        aaskey:value ?SubmodelReference ;
      ]
    ] .
  }
}
WHERE {
  ?AAS a aas:AssetAdministrationShell ;
    prov:wasDerivedFrom ?AASNode .

  ?Submodel a aas:Submodel .

  {
    ?Submodel prov:wasDerivedFrom ?NodeShape, ?PropertyShape .
    ?PropertyShape a sh:PropertyShape ;
      ^sh:property ?AASNode ;
      sh:class/^sh:targetClass ?NodeShape .
  } UNION {
    ?Submodel prov:wasDerivedFrom ?AASNode .
    ?AASNode mas4ai:hasInterface [] .
  
    FILTER NOT EXISTS { ?Submodel prov:wasDerivedFrom/sh:class [] }
  }

  BIND(STR(?Submodel) AS ?SubmodelReference)
}