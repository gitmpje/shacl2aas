INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
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

    MINUS {
      ?Value prov:wasDerivedFrom/a owl:NodeShape ;
        prov:wasDerivedFrom ?PropertyShape .
      FILTER NOT EXISTS { ?PropertyShape sh:maxCount 1 }
    }
  } UNION {
    # Cardinality>1 (datatype) properties
    ?SMC a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?PropertyShape .
    FILTER NOT EXISTS { ?SMC prov:wasDerivedFrom/a sh:NodeShape }

    ?Value a ?SubmodelElementType ;
      prov:wasDerivedFrom ?PropertyShape .
  }

  FILTER (?Value != ?SMC)
}