DELETE {
  ?SMC_parent aassmc:value ?SMC .
}
INSERT {
  ?SMC_parent aassmc:value ?ReferenceElement .
}
WHERE {
  ?ReferenceElement a aas:ReferenceElement ;
    aasrefe:value/aasref:keys/aaskey:value ?SMC .

  ?SMC a aas:SubmodelElementCollection .
  ?SMC_parent aassmc:value ?SMC .
  FILTER EXISTS {
    ?SMC_parent aassmc:value+ ?SMC .
    ?SMC aassmc:value+ ?SMC_parent .
  }
}