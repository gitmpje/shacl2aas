DELETE {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?SMC_parent aassmc:value ?SMC .
  }
}
INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?SMC_parent aassmc:value ?ReferenceElement_iri .

    ?ReferenceElement_iri a aas:ReferenceElement ;
      aassem:semanticId [
        a aas:Reference ;
        aasref:keys [
          a aas:Key ;
          aaskey:idType aaskeyt:IRI ;
          aaskey:value ?semanticIdValue ;
        ] ;
      ] ;
      aasrefe:value [
        a aas:Reference ;
        aasref:keys [
          a aas:Key ;
          aaskey:idType aaskeyt:SubmodelElementCollection ;
          aaskey:value ?SMC ;
        ] ;
      ] ;
      prov:wasDerivedFrom ?NodeShape, ?PropertyShape ;
      mas4ai:constructedByQuery "convert_smc_to_reference-element.ru" ;
    .
  }
}
WHERE {
  ?SMC a aas:SubmodelElementCollection ;
    aassem:semanticId/aasref:keys/aaskey:value ?semanticIdValue ;
    prov:wasDerivedFrom ?NodeShape, ?PropertyShape .

  ?NodeShape a sh:NodeShape .
  ?PropertyShape a sh:PropertyShape .

  # Find the SMC that is the entry point of the circular reference, and its parent SMC
  FILTER EXISTS {
    ?SMC aassmc:value+ ?SMC .
    ?Outside_parent aassm:submodelElements|aassmc:value ?SMC .

    MINUS { ?Outside_parent aassmc:value+ ?Outside_parent }
  }

  ?SMC_parent aassmc:value ?SMC .
  FILTER EXISTS { ?SMC_parent aassmc:value+ ?SMC_parent }

  BIND(iri(concat( "http://mas4ai.eu/id/referenceElement/template/", struuid() )) as ?ReferenceElement_iri)
}