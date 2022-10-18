INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?ElementSemanticReference aasref:keys [
      a aas:Key ;
      aaskey:idType aaskeyt:Iri ;
      aaskey:value ?SemanticId ;
    ] .
  }
}
WHERE {
  VALUES ?ElementType { aas:Submodel aas:SubmodelElementCollection aas:ReferenceElement }
  ?Element a ?ElementType ;
    aassem:semanticId ?ElementSemanticReference ;
    prov:wasDerivedFrom ?Shape .

  ?Shape sh:targetClass|sh:path ?SemanticId .

  # The semantic identifier should not be a class for which an AAS is constructed
  FILTER NOT EXISTS { ?Shape mas4ai:hasInterface [] }

  # A Submodel and its child elements should not have a class semantic identifier
  FILTER NOT EXISTS {
    { ?Element a aas:Submodel ; aassem:semanticId/aasref:keys/aaskey:value/^sh:targetClass/a sh:NodeShape }
    UNION
    { ?Element a aas:Submodel ; (aassm:submodelElements|aassmc:value)/aassem:semanticId/aasref:keys/aaskey:value/^sh:targetClass/a sh:NodeShape }
  }

  # An element should not already have the semantic identifier
  FILTER NOT EXISTS { ?Element aassem:semanticId/aasref:keys/aaskey:value ?SemanticId }

  # The parent element should not have the semantic identifier if it is a cardinality >1
  MINUS {
    ?Element ^(aassm:submodelElements|aassmc:value)/aassem:semanticId/aasref:keys/aaskey:value ?SemanticId .
    FILTER NOT EXISTS { ?SemanticId sh:maxCount 1 }
  }
}