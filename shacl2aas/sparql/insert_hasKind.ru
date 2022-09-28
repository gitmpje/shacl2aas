INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?Object aaskind:kind aasmod:Template .
  }
}
WHERE {
  ?Object a/rdfs:subClassOf* aas:HasKind .
  FILTER NOT EXISTS { ?Object aaskind:kind [] }
}