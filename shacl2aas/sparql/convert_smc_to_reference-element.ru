WITH <http://mas4ai.eu/id/graph/aas/template>
INSERT {
  ?ReferenceElement_iri a aas:ReferenceElement ;
    aassem:semanticId [
      a aas:Reference ;
      aasref:type aasreft:GlobalReference ;
      aasref:keys [
        a aas:Key ;
        aaskey:type aaskeyt:GlobalReference ;
        aaskey:value ?semanticIdValueStr ;
      ] ;
    ] ;
    aasrefe:value [
      a aas:Reference ;
      aasref:type aasreft:ModelReference ;
      aasref:keys [
        a aas:Key ;
        aaskey:type aaskeyt:SubmodelElementCollection ;
        aaskey:value ?SMCStr ;
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

  BIND(strdt(str(?semanticIdValue), xsd:string) AS ?semanticIdValueStr)
  BIND(strdt(str(?SMC), xsd:string) AS ?SMCStr)
  BIND(iri(concat( "http://mas4ai.eu/id/referenceElement/template/", struuid() )) as ?ReferenceElement_iri)
}