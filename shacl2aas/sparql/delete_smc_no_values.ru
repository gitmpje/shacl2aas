DELETE {
    ?Parent ?relation ?SMC .
    ?SMC ?p ?o .
    ?o ?p2 ?o2 .
    ?o2 ?p3 ?o3 .
}
WHERE {
    ?SMC a aas:SubmodelElementCollection ;
        ?p ?o .
    OPTIONAL { ?Parent ?relation ?SMC }
    OPTIONAL {
        ?o ?p2 ?o2 .
        OPTIONAL { ?o2 ?p3 ?o3 }
    }
    FILTER NOT EXISTS { ?SMC aassmc:value ?SubmodelElement }
}