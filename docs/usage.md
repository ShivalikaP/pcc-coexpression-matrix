# Usage Guide — PCC Pipeline

Detailed reference for running the Perl Pearson Correlation Coefficient pipeline.

---

## Table of Contents

1. [Overview](#overview)
2. [Algorithm](#algorithm)
3. [Input Format](#input-format)
4. [Running the Pipeline](#running-the-pipeline)
5. [Output Format](#output-format)
6. [Arguments Reference](#arguments-reference)
7. [Running cor.pl Standalone](#running-corpl-standalone)
8. [Troubleshooting](#troubleshooting)

---

## Overview

The pipeline consists of two scripts:

| Script | Role |
|--------|------|
| `scripts/PCC_main.pl` | Outer loop — iterates all query × reference gene pairs |
| `scripts/cor.pl` | Inner computation — computes PCC for one query vs one or more reference genes |

`PCC_main.pl` extracts one gene at a time from each file, writes it to a temporary file, and calls `cor.pl` to compute the PCC. Results are appended to the output file.

---

## ⚡ Quick Start

```bash
# Using modernized scripts (recommended)
perl scripts/PCC_main.pl data/query.tsv data/reference.tsv results/PCC_output.txt

# Using original scripts
perl PCC_main.pl query.tsv reference.tsv
```

---

## Algorithm

The Pearson Correlation Coefficient between a query gene **X** and a reference gene **Y** across *n* conditions is:

$$r = \frac{SS_{xy}}{\sqrt{SS_{xx} \cdot SS_{yy}}}$$

Where:

$$SS_{xy} = \sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})$$
$$SS_{xx} = \sum_{i=1}^{n} (x_i - \bar{x})^2$$
$$SS_{yy} = \sum_{i=1}^{n} (y_i - \bar{y})^2$$

- **r = 1.0**: perfect positive correlation
- **r = −1.0**: perfect negative correlation
- **r = 0.0**: no linear correlation

---

## Input Format

Both input files must be **tab-separated** with the following structure:

```
gene_id <TAB> value1 <TAB> value2 <TAB> ... <TAB> valueN
```

- First column: gene or feature identifier (string)
- Remaining columns: numeric expression values (one per condition/sample)
- Both files must have the **same number of value columns** per row
- No header row expected

### Example query file

```
GeneA	1.2	3.4	2.1	4.5	1.8
GeneB	5.0	4.0	3.0	2.0	1.0
```

### Example reference file

```
RefGene1	1.1	3.2	2.3	4.3	1.9
RefGene2	5.1	4.1	3.1	2.1	1.1
RefGene3	1.0	1.5	5.0	1.5	1.0
```

---

## Running the Pipeline

```bash
perl scripts/PCC_main.pl <query_file> <reference_file> [output_file]
```

### Minimal run (output defaults to `PCC_output`)

```bash
perl scripts/PCC_main.pl data/query.tsv data/reference.tsv
```

### Specifying an output file

```bash
perl scripts/PCC_main.pl data/query.tsv data/reference.tsv results/my_pcc.txt
```

### Using the original scripts

```bash
perl PCC_main.pl query.tsv reference.tsv
# output appended to: PCC_output (hardcoded)
```

---

## Output Format

Tab-separated, one line per gene pair, sorted by PCC descending within each query gene:

```
query_gene_id <TAB> ref_gene_id <TAB> PCC_value
```

### Example output

```
GeneA	RefGene1	0.9987
GeneA	RefGene3	0.1453
GeneA	RefGene2	-0.9921
GeneB	RefGene2	0.9999
GeneB	RefGene1	-0.9921
GeneB	RefGene3	-0.2105
```

PCC values are rounded to 4 decimal places.

---

## Arguments Reference

### `PCC_main.pl`

| Argument | Required | Description |
|----------|----------|-------------|
| `query_file` | Yes | Tab-separated gene expression file (query set) |
| `reference_file` | Yes | Tab-separated gene expression file (reference set) |
| `output_file` | No | Output filename; defaults to `PCC_output` |

### `cor.pl`

| Argument | Required | Description |
|----------|----------|-------------|
| `query_file` | Yes | Single-gene tab-separated file |
| `reference_file` | Yes | One or more reference gene tab-separated file |

---

## Running cor.pl Standalone

`cor.pl` can be called independently to compute PCC between one query gene and one reference gene:

```bash
# create single-gene files
echo "GeneA	1.2	3.4	2.1	4.5	1.8" > /tmp/q.tsv
echo "RefGene1	1.1	3.2	2.3	4.3	1.9" > /tmp/r.tsv

perl scripts/cor.pl /tmp/q.tsv /tmp/r.tsv
```

Output:
```
GeneA	RefGene1	0.9987
```

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---------|-------------|-----|
| `Cannot open query file` | Wrong path or file does not exist | Check the file path and permissions |
| `Cannot find cor.pl` | `cor.pl` not in `scripts/` | Run `PCC_main.pl` from the repo root, or check `$Bin` path |
| Empty or missing output | Gene pair had zero variance | A constant expression vector produces `r = 0` — this is expected |
| Results not sorted globally | By design | Results are sorted per query gene, not globally across all pairs |
| Mismatched column counts | Both files must have the same number of values | Check that every row has the same number of tab-separated columns |

---

## ✅ Requirements

- Perl 5 (no non-core modules required)
