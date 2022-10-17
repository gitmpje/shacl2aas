INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?Object aasrefer:idShort ?idShort ;
      rdfs:label ?label ;
      aasrefer:description ?description ;
      aasrefer:displayName ?displayName ;
    .
  }
}
WHERE {
  # Join Property and Class label
  { SELECT
      ?Object
      (CONCAT(?propertyLabel, "__", ?nodeLabel) as ?_idShort)
      (IF(bound(?NodeShape), ?NodeShape, ?_PropertyShape) as ?SourceShape)
      (IF(BOUND(?_PropertyShape), ?_PropertyShape, BNODE()) AS ?PropertyShape)
    WHERE {
        ?Object a/rdfs:subClassOf* aas:Referable ;
        OPTIONAL {
          ?Object aassem:semanticId/aasref:keys/aaskey:value ?Class .
          ?NodeShape a sh:NodeShape ;
            rdfs:label ?nodeLabel ;
            sh:targetClass ?Class .
        }
        OPTIONAL {
          ?Object aassem:semanticId/aasref:keys/aaskey:value ?property .
          ?_PropertyShape a sh:PropertyShape ;
            rdfs:label ?propertyLabel ;
            sh:path ?property .
        }
  } }

  ?Object prov:wasDerivedFrom ?SourceShape .
  ?SourceShape rdfs:label ?label .
  OPTIONAL {
    ?SourceShape rdfs:label ?label_en .
    FILTER(lang(?label_en)='en')
  }

  BIND ( REPLACE(str(?SourceShape), ".+[//#]([a-z0-9_]+)$", "$1") as ?noLabel)
  BIND ( REPLACE(COALESCE(?_idShort, ?label_en, ?label, ?noLabel), "[-//(), ]", "_") AS ?_idShort )

  # Plural idShort on Submodel or SMC of not cardinality one properties
  BIND (
    IF(
      EXISTS {
        ?Object prov:wasDerivedFrom ?NodeShape , ?PropertyShape ;
          (aassm:submodelElements|aassmc:value)/prov:wasDerivedFrom ?NodeShape , ?PropertyShape .
        ?NodeShape a sh:NodeShape .
        ?PropertyShape a sh:PropertyShape .
      } &&
      NOT EXISTS { ?PropertyShape sh:maxCount 1 },
      CONCAT(?_idShort, "s"),
      ?_idShort
    ) AS ?idShort
  )

  OPTIONAL {
    ?SourceShape rdfs:comment ?comment .
    # If comment has no language tag, add default "en" tag
    BIND ( IF(langMatches( lang(?comment), "*" ), ?comment, STRLANG(?comment, "en")) AS ?description )
  }

  OPTIONAL {
    ?SourceShape skos:prefLabel ?prefLabel .
    OPTIONAL { ?Object aasrefer:displayName ?_displayName }
    BIND ( COALESCE(?_displayName, ?prefLabel) AS ?displayName )
  }
}