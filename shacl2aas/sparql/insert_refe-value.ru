INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?ReferenceElement aasrefe:value [
        a aas:Reference ;
        aasref:keys [
          a aas:Key ;
          aaskey:idType aaskeyt:Iri ;
          aaskey:value ?_ReferenceAAS ;
        ] ;
      ] ;
    .
  }
}
WHERE {
  ?ReferenceElement a aas:ReferenceElement ;
    prov:wasDerivedFrom ?NodeShape, ?PropertyShape .

  ?PropertyShape sh:class/^sh:targetClass ?NodeShape .

  ?ReferenceAAS a aas:AssetAdministrationShell ;
    prov:wasDerivedFrom ?NodeShape .

  FILTER EXISTS { ?NodeShape mas4ai:hasInterface [] }

  BIND(str(?ReferenceAAS) as ?_ReferenceAAS)
}