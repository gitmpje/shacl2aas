INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?Object aasida:id ?id
  }
}
WHERE {
  ?Object a/rdfs:subClassOf* aas:Identifiable .

  BIND(STRDT(STR(?Object), xsd:string) AS ?id)
}