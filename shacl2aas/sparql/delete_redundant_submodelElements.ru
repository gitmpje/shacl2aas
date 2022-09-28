DELETE {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?Submodel aassm:submodelElements ?SMC2 .
}
}
WHERE {
  ?Submodel aassm:submodelElements ?SMC , ?SMC2.
  ?SMC aassmc:value ?SMC2 .

  MINUS {
    ?Submodel prov:wasDerivedFrom ?NodeShape , ?PropertyShape .
    ?SMC2 prov:wasDerivedFrom ?NodeShape , ?PropertyShape .
    ?NodeShape a sh:NodeShape .
    ?PropertyShape a owl:PropertyShape .
  }
  MINUS {
    ?Submodel prov:wasDerivedFrom/sh:maxCount 1 .
  }
}