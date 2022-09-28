import re

from rdflib import Graph, URIRef, Variable

# Add prefixes to RDFlib Graph
def add_prefixes(graph: Graph()):
    with open("shacl2aas/sparql/prefixes.sparql", "r") as f:
        prefixes = f.read().split('\n')

    for prefix in prefixes:

        prefix.strip()
        k = re.findall("^PREFIX ([a-z0-9]+)", prefix)[0]
        v = re.findall("<(.+)>$", prefix)[0]

        graph.bind(k, URIRef(v))


def drop_inverse_properties(g_owl: Graph): #TODO: convert to SHACL
  add_prefixes(g_owl)
  classes = [s for s in g_owl.subjects(predicate=URIRef("http://example.org/MAS4AI_GenericModel#hasInterface"))]
  prev_classes = []
  properties = []

  while classes:

      _class = classes.pop()
      prev_classes.append(_class)
      results = g_owl.query('''
  SELECT ?Property ?RangeClass
  WHERE {
    ?Property a owl:ObjectProperty ;
      rdfs:domain ?Class ;
      rdfs:range ?RangeClass .
  }
  ''', initBindings={"Class": _class}).bindings

      for r in results:

          if r[Variable("RangeClass")] not in prev_classes:
            properties.append(r[Variable("Property")])
            classes.append(r[Variable("RangeClass")])

  if properties:
      g_owl.update('''
  DELETE {
    ?InverseProperty ?p ?o .
  }
  WHERE {
    VALUES ?Property {%(properties)s}

    { ?Property owl:inverseOf ?InverseProperty }
    UNION
    { ?InverseProperty owl:inverseOf ?Property }

    FILTER(?InverseProperty != ?Property)
    ?InverseProperty ?p ?o .
  }
  ''' % {"properties": "<"+"> <".join(set(p.toPython() for p in properties))+">"})


def infer_properties(g_shacl: Graph):
    g_shacl.update('''
INSERT {
  ?SubClass sh:property ?PropertyShape
}
WHERE {
  VALUES ?PropertyType {owl:ObjectProperty owl:DatatypeProperty}
  ?Property a ?PropertyType ;
    rdfs:domain ?Class .
  ?PropertyShape sh:path ?Property.
  ?SubClass rdfs:subClassOf+ ?Class .
}
''')


def enrich_shapes(g_shacl: Graph):
    g_shacl.update('''
INSERT {
  ?Shape ?p ?value
}
WHERE {
  VALUES ?p { rdfs:label rdfs:comment skos:prefLabel }
  ?Shape sh:targetClass|sh:path [ ?p ?value ]
}
''')