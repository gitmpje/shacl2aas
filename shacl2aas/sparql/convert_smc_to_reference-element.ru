WITH <http://mas4ai.eu/id/graph/aas/template>
INSERT {
  ?ReferenceElement_iri a aas:ReferenceElement ;
    aassem:semanticId [
      a aas:Reference ;
      aasref:keys [
        a aas:Key ;
        aaskey:idType aaskeyt:Iri ;
        aaskey:value ?semanticIdValue ;
      ] ;
    ] ;
    aasrefe:value [
      a aas:Reference ;
      aasref:keys [
        a aas:Key ;
        aaskey:idType aaskeyt:Iri ;
        aaskey:value ?SMC ;
      ] ;
    ] ;
    prov:wasDerivedFrom ?NodeShape, ?PropertyShape ;
    mas4ai:constructedByQuery "convert_smc_to_reference-element.ru" ;
  .
}
WHERE {
  ?SMC a aas:SubmodelElementCollection ;
    aassem:semanticId/aasref:keys/aaskey:value ?semanticIdValue ;
    prov:wasDerivedFrom ?NodeShape, ?PropertyShape .

  GRAPH <http://mas4ai.eu/id/graph/shacl> {
    ?NodeShape a sh:NodeShape .
    ?PropertyShape a sh:PropertyShape .
  }

  # SMC should be in a circular reference
  FILTER EXISTS { ?SMC aassmc:value+ ?SMC }

  BIND(iri(concat( "http://mas4ai.eu/id/referenceElement/template/", struuid() )) as ?ReferenceElement_iri)
}