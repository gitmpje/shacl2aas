INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?SMC aassmc:value ?Value .
  }
}
WHERE {
  ?SubmodelElementType rdfs:subClassOf+ aas:SubmodelElement .

  {
    ?SMC a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?NodeShape .

    ?NodeShape a sh:NodeShape ;
      sh:property ?PropertyShape .

    ?Value a ?SubmodelElementType ;
      prov:wasDerivedFrom ?PropertyShape .

    # The value object should not be derived from a NodeShape, unless it is a cardinality one property
    FILTER ( 
      NOT EXISTS { ?Value prov:wasDerivedFrom/a sh:NodeShape } ||
      EXISTS { ?PropertyShape sh:maxCount 1 }
    )
  } UNION {
    # Non cardinality one properties
    ?SMC a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?PropertyShape .
    FILTER NOT EXISTS { ?SMC prov:wasDerivedFrom/a sh:NodeShape }

    ?PropertyShape a sh:PropertyShape .

    ?Value a ?SubmodelElementType ;
      prov:wasDerivedFrom ?PropertyShape .

    FILTER (?Value != ?SMC)
  }
}