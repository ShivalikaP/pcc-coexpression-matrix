# Perl-script-to-calculate-Pearson-correlation-coefficient

![Perl](https://img.shields.io/badge/Perl-5%2B-blue?logo=perl&logoColor=white)
![License](https://img.shields.io/badge/license-GPL--3.0-green)
![Status](https://img.shields.io/badge/status-maintained-brightgreen)

Batch Pearson Correlation Coefficient (PCC) calculator written in Perl.
Computes all-vs-all gene expression correlations between a query set and a reference set.

Originally developed at **CSIR-IHBT** for bioinformatics gene expression analysis.

---

## 🧬 What it does

Given two tab-separated gene expression files, the pipeline computes the **Pearson Correlation Coefficient** for every query gene paired with every reference gene, then sorts results by PCC in descending order.

---

## 📁 Repository Structure

```
.
├── PCC_main.pl              # Original main script (preserved)
├── cor.pl                   # Original correlation script (preserved)
├── scripts/
│   ├── PCC_main.pl          # Modernized main script (recommended)
│   └── cor.pl               # Modernized correlation script (recommended)
├── examples/
│   ├── query.tsv            # Example query gene expression input
│   ├── reference.tsv        # Example reference gene expression input
│   └── output_example.txt   # Expected output format
├── docs/
│   └── usage.md             # Detailed usage and format guide
├── data/                    # Your input data (gitignored)
└── results/                 # Your output results (gitignored)
```

---

## ⚡ Quick Start

```bash
# Using modernized scripts (recommended)
perl scripts/PCC_main.pl examples/query.tsv examples/reference.tsv results/PCC_output.txt

# Using original scripts
perl PCC_main.pl query.tsv reference.tsv
```

---

## 📋 Input Format

Tab-separated, one gene per line: `gene_id <TAB> value1 <TAB> value2 ...`

```
GeneA    1.2    3.4    2.1    4.5    1.8
GeneB    5.0    4.0    3.0    2.0    1.0
```

Both the query and reference files must have the same number of expression values per gene.

---

## 📄 Output Format

Tab-separated: `query_gene <TAB> reference_gene <TAB> PCC_value`

```
GeneA    RefGene1    0.9987
GeneA    RefGene3    0.1453
GeneA    RefGene2   -0.9921
```

Results within each query gene are sorted highest-to-lowest PCC.

---

## 🔬 How it works

`PCC_main.pl` iterates over every query gene and every reference gene, writing each pair to temporary files and calling `cor.pl` to compute the PCC. The Pearson formula used is:

$$r = \frac{SS_{xy}}{\sqrt{SS_{xx} \cdot SS_{yy}}}$$

See [docs/usage.md](docs/usage.md) for the full algorithm description, argument reference, and troubleshooting.

---

## ✅ Requirements

- Perl 5 (no non-core modules required)

---

## 👩‍💻 Author

**Shivalika Pathania** — CSIR-IHBT

---

## 📄 License

[GNU General Public License v3.0](LICENSE)

