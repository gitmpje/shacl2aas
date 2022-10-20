INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?Submodel aassm:submodelElements ?SubmodelElement .
  }
}
WHERE {
  {
    # Datatype properties
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom ?NodeShape .

    ?NodeShape sh:property ?PropertyShape .
    FILTER EXISTS { ?PropertyShape sh:datatype [] }

    ?SubmodelElement prov:wasDerivedFrom ?PropertyShape .

    MINUS {
      ?Submodel prov:wasDerivedFrom/sh:class [] ;
        prov:wasDerivedFrom/mas4ai:hasInterface [] .
    }

    # Exclude nested submodel elements
    MINUS {
      ?Submodel a aas:Submodel .

      # Only if the submodel is derived from a not cardinality one property
      FILTER NOT EXISTS { ?Submodel prov:wasDerivedFrom/sh:maxCount 1 }

      # Only if the submodel is not derived from an AAS node
      FILTER NOT EXISTS { ?Submodel prov:wasDerivedFrom/mas4ai:hasInterface [] }
    }
  } UNION {
    # Nested properties for 'cardinality one submodel'
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom/sh:maxCount 1 ;
      prov:wasDerivedFrom ?NodeShape .

    ?SubmodelElement a/rdfs:subClassOf+ aas:SubmodelElement ;
      prov:wasDerivedFrom ?PropertyShape .

    ?NodeShape sh:property ?PropertyShape .

    # The element should not be derived from a NodeShape, unless it is a cardinality one property
    FILTER ( 
      NOT EXISTS { ?SubmodelElement prov:wasDerivedFrom/a sh:NodeShape } ||
      EXISTS { ?PropertyShape sh:maxCount 1 }
    )
  } UNION {
    # Non cardinality one object properties
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom ?NodeShape, ?PropertyShape .

    ?SubmodelElement a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?NodeShape, ?PropertyShape .

    ?PropertyShape sh:class/^sh:targetClass ?NodeShape .
  } UNION {
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom ?PropertyShape .

    ?SubmodelElement a aas:ReferenceElement ;
      prov:wasDerivedFrom ?PropertyShape .

    FILTER EXISTS { ?PropertyShape sh:class [] }
  }
}