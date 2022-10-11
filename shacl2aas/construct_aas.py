import os

from xmlrpc.client import Boolean
from rdflib import BNode, ConjunctiveGraph, Dataset, Graph, URIRef
from pathlib import Path

from shacl2aas.helpers import add_prefixes, infer_properties, enrich_shapes

# Main directory
MAIN_DIR = os.path.dirname(os.path.abspath(__file__))

# Directory for storing logs and debug files
LOGS_DIR = os.path.join(MAIN_DIR, "logs")


def initialize_dataset(g_in: Graph):

    # Initialize a Dataset
    dataset = Dataset()

    # Add input ontology graph to dataset (assume has identifier "http://mas4ai.eu/id/graph/shacl")
    g_shacl = dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/shacl"))
    g_shacl.parse(data=g_in.serialize())

    # Add AAS RDF ontology graph to dataset
    g_AAS_ont = dataset.graph(identifier=URIRef("https://admin-shell.io/aas/3/0/RC02/"))
    g_AAS_ont.parse(os.path.join(MAIN_DIR, "rdf-ontology_V3.0.5RC02.ttl"), format="text/turtle")
    # g_AAS_ont.parse("https://raw.githubusercontent.com/admin-shell-io/aas-specs/master/schemas/rdf/rdf-ontology.ttl", format="text/turtle")

    # Add graph to store the AAS Template graph in
    dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/aas/template"))

    return dataset, g_shacl


def construct_aas(g_in: Graph, g_in_path: str, debug: Boolean):

    # Initialize graphs and dataset
    dataset, g_shacl = initialize_dataset(g_in)
    g_out = dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/aas"))
    g_conj = ConjunctiveGraph(dataset.store)
    add_prefixes(dataset)


    # Enrich input graph (consider relocating to separate function)
    imports = [o for o in g_shacl.objects(predicate=URIRef("http://www.w3.org/2002/07/owl#imports"))]
    for file in imports:
        # First check if file is in same folder as input graph
        try:
            local_file = os.path.join(os.path.split(g_in_path)[0], file.toPython().strip('#/').split('/')[-1])
            g_shacl.parse(local_file)
            print('imported: ', local_file)
        except FileNotFoundError:
            try:
                g_shacl.parse(file.toPython())
                print('imported: ', file.toPython())
            except:
                print('Cannot import ', file.toPython())

    # drop_inverse_properties(g_shacl)
    enrich_shapes(g_shacl)
    infer_properties(g_shacl)

    if debug:
        g_shacl.serialize(os.path.join(LOGS_DIR, "g_shacl.ttl"))
        print(f"Stored enriched shapes graph to {os.path.join(LOGS_DIR, 'g_shacl.ttl')}")

    # Load SPARQL files into memory
    sparql_files = list(Path("shacl2aas/sparql/").rglob("*.r[qu]"))
    for file in sparql_files:
        file_var_name = file.name.strip('.rqu').lower().replace('-','_')
        globals()[file_var_name] = open(file, 'r').read()


    # Run SPARQL to construct AAS
    # TODO: use SPARQL INSERT?
    g_out.parse(data=g_shacl.query(construct_property).graph.serialize())

    add_prefixes(dataset)
    g_out.parse(data=g_shacl.query(construct_multi_lang_property).graph.serialize())

    add_prefixes(dataset)
    g_out.parse(data=g_shacl.query(construct_reference_element).graph.serialize())

    add_prefixes(dataset)
    g_out.parse(data=g_shacl.query(construct_smc_non_aas_class).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_shacl.query(construct_smc_cardinality_datatype_prop).graph.serialize())
    add_prefixes(dataset)
    g_conj.update(insert_smc_value)
    add_prefixes(dataset)
    g_out.update(delete_smc_no_values)

    add_prefixes(dataset)
    g_out.parse(data=g_shacl.query(construct_submodel).graph.serialize())
    add_prefixes(dataset)
    g_conj.update(insert_sm_submodelelements)
    add_prefixes(dataset)
    g_conj.update(delete_redundant_submodelelements)

    add_prefixes(dataset)
    g_conj.update(convert_smc_to_reference_element)

    add_prefixes(dataset)
    g_out.parse(data=g_shacl.query(construct_asset_administration_shell).graph.serialize())
    add_prefixes(dataset)
    g_conj.update(insert_aas_submodels)
    add_prefixes(dataset)
    g_conj.update(insert_refe_value)

    add_prefixes(dataset)
    g_conj.update(insert_aas_environment)

    add_prefixes(dataset)
    g_conj.update(insert_haskind)
    add_prefixes(dataset)
    g_conj.update(insert_referable_attributes)

    return g_out