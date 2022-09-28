# SHACL2AAS

SHACL2AAS is a tool to convert an [RDF based SHACL](https://www.w3.org/TR/shacl/) shapes graph to a basic Asset Administration Shell (AAS) Template for Industry 4.0 Systems,
compliant with the meta model specification provided in
[the document “Details of the Asset Administration Shell” (v3.0RC02)](https://https://www.plattform-i40.de/IP/Redaktion/EN/Downloads/Publikation/Details_of_the_Asset_Administration_Shell_Part1_V3.html).


## Features

* Conversion of SHACL shapes graph to a basic AAS, both using RDF syntax.


<!-- ### Project Structure -->


<!-- ## License -->


## Dependencies

SHACL2AAS requires the following Python packages to be installed for production usage. These dependencies are listed in
`setup.py` to be fetched automatically when installing with `pip`:
* `rdflib` and its dependencies (BSD 3-clause License)


## Getting Started

### Installation

You can install SHACL2AAS using pip:

```bash
pip install -r requirements.txt
```


### Example

Example usage `python -m shacl2aas.cli 'test/resources/mas4aiDEMO.shapes.ttl' -c 'http://www.tno.nl/mas4aiDEMO#RoboticArm' -o test/mas4aiDEMO_template.aas.ttl`
Generates `mas4aiDEMO_template.aas.ttl` file with the basic AAS template for a 'Robotic Arm' (NodeShape).
If we also need an AAS Template for a 'Tool' (NodeShape), we can use `python -m shacl2aas.cli 'test/resources/mas4aiDEMO.shapes.ttl' -c 'http://www.tno.nl/mas4aiDEMO#RoboticArm' 'http://www.tno.nl/mas4aiDEMO#Tool' -o test/mas4aiDEMO_templates.aas.ttl`.


## Contributing

If you would like to contribute, please get in touch with us: mark.van.der.pas@semaku.com


<!-- ### Codestyle and Testing

Our code follows the [PEP 8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/).
Additionally, we use [PEP 484 -- Type Hints](https://www.python.org/dev/peps/pep-0484/) throughout the code to enable type checking the code.


### Contribute Code/Patches

TBD -->