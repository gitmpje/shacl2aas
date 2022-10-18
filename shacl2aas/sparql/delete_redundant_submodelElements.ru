DELETE {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?Submodel aassm:submodelElements ?SME_redundant .
  }
}
WHERE {
  ?Submodel aassm:submodelElements ?SME , ?SME_redundant.
  ?SME prov:wasDerivedFrom/sh:property/^prov:wasDerivedFrom ?SME_redundant .
  FILTER(?SME != ?SME_redundant)

  FILTER NOT EXISTS {
    ?Submodel prov:wasDerivedFrom ?NodeShape , ?PropertyShape .
    ?SME_redundant prov:wasDerivedFrom ?NodeShape , ?PropertyShape .
    ?NodeShape a sh:NodeShape .
    ?PropertyShape sh:class/^sh:targetClass ?NodeShape .
  }
  FILTER NOT EXISTS {
    ?Submodel prov:wasDerivedFrom ?NodeShape , ?PropertyShape .
    ?SME_redundant prov:wasDerivedFrom ?NodeShape , ?PropertyShape .
    ?NodeShape mas4ai:hasInterface [] .
    ?PropertyShape a sh:PropertyShape .
  }
  FILTER NOT EXISTS {
    ?Submodel prov:wasDerivedFrom/sh:maxCount 1 .
    MINUS { ?Submodel prov:wasDerivedFrom/mas4ai:hasInterface [] }
  }
}