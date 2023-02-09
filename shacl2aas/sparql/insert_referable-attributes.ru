INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?Object aasrefer:idShort ?idShort ;
      rdfs:label ?label ;
      aasrefer:description ?description ;
      aasrefer:displayName ?displayName ;
    .
  }
}
WHERE {
  ?Object a/rdfs:subClassOf* aas:Referable .

  { SELECT DISTINCT ?Object (GROUP_CONCAT(DISTINCT ?shapeLabel) as ?_idShort) {
    {
      # In case of a Reference Element, always use both the Property and Node Shape label in the idShort
      ?Object a aas:ReferenceElement ;
        prov:wasDerivedFrom ?Shape .

      OPTIONAL { ?Shape rdfs:label ?_shapeLabel }
    } UNION {
      # Get idShort from semanticId both Node and Property Shape labels
      ?Object aassem:semanticId/aasref:keys/aaskey:value/^(sh:targetClass|sh:path) ?Shape ;
        prov:wasDerivedFrom ?Shape .
      OPTIONAL { ?Shape rdfs:label ?_shapeLabel }

      FILTER NOT EXISTS { ?Object a aas:ReferenceElement }
    } UNION {
      # Get idShort from derived from Shape if there is no semanticId
      ?Object prov:wasDerivedFrom ?Shape .
      OPTIONAL { ?Shape rdfs:label ?_shapeLabel }

      FILTER NOT EXISTS { ?Object aassem:semanticId [] }      
    }

    # Prefer English labels to be used for idShort
    FILTER(lang(?_shapeLabel)="en" || lang(?_shapeLabel)="")
    BIND ( COALESCE(?_shapeLabel, REPLACE(str(?Shape), ".+[//#]([a-zA-Z0-9_-]+)$", "$1")) as ?shapeLabel )
  } GROUP BY ?Object }

  # Plural idShort on Submodel or SMC of not cardinality one properties
  BIND ( REPLACE(?_idShort, "[-//(), ]", "_") AS ?__idShort )
  BIND (
    IF(
      EXISTS {
        ?Object prov:wasDerivedFrom ?PropertyShape ;
          (aassm:submodelElements|aassmc:value)/prov:wasDerivedFrom ?PropertyShape .
        ?PropertyShape a sh:PropertyShape .
      } &&
      NOT EXISTS { ?PropertyShape sh:maxCount 1 },
      CONCAT(?__idShort, "s"),
      ?__idShort
    ) AS ?idShort
  )

  # Get other attributes from a (derived from) Shape
  { SELECT DISTINCT ?Object (SAMPLE(?_description) AS ?description) (SAMPLE(?displayName_lang) AS ?displayName) {
    ?Object aassem:semanticId/aasref:keys/aaskey:value/^(sh:targetClass|sh:path) ?SourceShape .

    OPTIONAL {
      ?SourceShape rdfs:comment ?comment .
      # If comment has no language tag, add default "en" tag
      BIND ( IF(langMatches( lang(?comment), "*" ), ?comment, STRLANG(?comment, "en")) AS ?_description )
    }

    OPTIONAL {
      ?SourceShape skos:prefLabel ?prefLabel .
      OPTIONAL { ?Object aasrefer:displayName ?_displayName }
      BIND ( COALESCE(?_displayName, ?prefLabel) AS ?__displayName )
      # If displayName has no language tag, add default "en" tag
      BIND ( IF(langMatches( lang(?__displayName), "*" ), ?__displayName, STRLANG(?__displayName, "en")) AS ?displayName_lang )

    }

  } GROUP BY ?Object }
}