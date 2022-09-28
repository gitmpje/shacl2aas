INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?Submodel aassm:submodelElements ?SubmodelElement .
  }
}
WHERE {
  {
    # Properties
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

      # Only if the submodel is derived from a cardinality >1 property
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
  } UNION {
    # Cardinality >1 object properties
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