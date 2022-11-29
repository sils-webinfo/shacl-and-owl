# SHACL and OWL

For this assignment you will try your hand at

* creating SHACL shapes to validate data, and
* creating an OWL ontology to make inferences about data.

The data can either be a variation of the same Rijksmuseum data you've
used for past assignments, or a new dataset you come up yourself.

You will be editing four files:

1. `data-invalid.ttl`
    A version of your data that is expected to **fail** SHACL validation.
1. `data-valid.ttl`
    A version of your data that is expected to **pass** SHACL validation.
1. `shapes.ttl`
    The SHACL shapes that `data-valid.ttl` (but *not* `data-invalid.ttl`) should conform to.
1. `ontology.ttl`
    An OWL ontology that enables inferences over `data-valid.ttl`.

## Validating with SHACL

1. Create two copies of your data file and name them `data-invalid.ttl` and `data-valid.ttl`.

1. Edit `shapes.ttl`, writing some shapes that you expect your data will *not* conform to. 

1. Run `make report-invalid.ttl` to validate `data-invalid.ttl` using your shapes.

1. Open `report-invalid.ttl`; at the top you should see:
    
    ```
    [ rdf:type     sh:ValidationReport ;
      sh:conforms  false ;
    ```

    … telling you that validation failed (as expected).

1. Edit `data-valid.ttl`, fixing the problems that were causing `data-invalid.ttl` not to validate.

1. Run `make report-valid.ttl` to validate `data-valid.ttl` using your shapes.

1. Open `report-valid.ttl`; at the top you should see:
    
    ```
    [ rdf:type     sh:ValidationReport ;
      sh:conforms  true
    ] .
    ```

    … telling you that validation succeeded (as expected).

You'll probably want to refer to the [core constraint components](https://www.w3.org/TR/shacl/#core-components) in the SHACL specification, as well as the [example](shapes.ttl) I've provided. This [Introduction to SHACL](https://www.ida.liu.se/~robke04/SHACLTutorial/Introduction%20to%20SHACL.pdf) may also be helpful.

## Inferring with OWL

1. Edit `ontology.ttl`, writing some class and property definitions that will enable inferences over your data.

1. Run `make all.ttl` to generate `all.ttl`, which will include the triples from `data-valid.ttl` plus any new triples inferred from `data-valid.ttl` and `ontology.ttl`. (This will also generate `inferred.ttl`, which will include only the inferred triples.)

1. Verify that `all.ttl` includes the inferred triples that you expected to see.

You may want to refer to the [OWL 2 Primer](https://www.w3.org/TR/owl2-primer/), as well as the examples [[1](https://github.com/sils-webinfo/owl/blob/main/ontology.ttl), [2](ontology.ttl)] I've provided.

## Submitting the assignment

To submit the assignment, run:

```
make submission.zip
```

This will check that:

* `data-invalid.ttl` *does not* conform to `shapes.ttl`
* `data-valid.ttl` *does* conform to `shapes.ttl`
* `inferred.ttl` contains triples inferred from `data-valid.ttl` and `ontology.ttl`

You will get an error if any of these checks do not pass.

Once the checks pass, submit the zip file at 
https://aeshin.org/teaching/assignment/212/submit/

Finally, you should [commit](https://docs.github.com/en/codespaces/developing-in-codespaces/using-source-control-in-your-codespace#committing-your-changes) and [push](https://docs.github.com/en/codespaces/developing-in-codespaces/using-source-control-in-your-codespace#pushing-changes-to-your-remote-repository) the following files:

1. `data-invalid.ttl`
1. `data-valid.ttl`
1. `shapes.ttl`
1. `ontology.ttl`



