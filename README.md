# Pearson Correlation Coefficient Calculator for Co-expression Analysis

![Perl](https://img.shields.io/badge/Perl-5%2B-blue?logo=perl&logoColor=white)
![License](https://img.shields.io/badge/license-GPL--3.0-green)
![Status](https://img.shields.io/badge/status-maintained-brightgreen)

A Perl-based tool for computing all-vs-all Pearson Correlation Coefficients between two biologically distinct feature sets such as transcription factors and target genes, or small RNAs and genes, across shared expression samples. Generates co-expression matrices suitable for regulatory network construction and downstream analysis.

Originally developed at **CSIR-IHBT** as part of PhD research on co-expression analysis in secondary metabolite biosynthesis pathways. Now being updated with improved documentation and structure while preserving the original analytical purpose.

---

## 🧬 Biological Application

This tool is designed for cases where the two feature sets differ in biological role and optionally in size. Typical use cases include:

- Transcription factor – gene co-expression analysis
- Small RNA – gene co-expression analysis
- Identification of candidate regulatory relationships
- Generation of co-expression matrices for network construction and visualization

By computing pairwise correlations across expression profiles, the script helps identify candidate regulatory associations for downstream network inference workflows.

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
│   ├── query.tsv            # Example query feature expression input
│   ├── reference.tsv        # Example reference feature expression input
│   └── output_example.txt   # Expected output format
├── docs/
│   └── usage.md             # Detailed usage and format guide
├── data/                    # Your input data (gitignored)
└── results/                 # Your output results (gitignored)
```

---

## ⚡ Quick Start

```bash
# Recommended (modernized scripts)
perl scripts/PCC_main.pl examples/query.tsv examples/reference.tsv results/PCC_output.txt

# Original scripts (preserved as-is)
perl PCC_main.pl query.tsv reference.tsv
```

---

## 🔬 How it works

`PCC_main.pl` iterates over every query feature paired with every reference feature, calling `cor.pl` to compute the PCC for each pair. The Pearson formula used is:

$$r = \frac{SS_{xy}}{\sqrt{SS_{xx} \cdot SS_{yy}}}$$

See [docs/usage.md](docs/usage.md) for the full algorithm description, argument reference, and troubleshooting.

---

## 📖 Citation

If you use this code, please cite:

> **Pathania S, Acharya V.** Computational Analysis of "-omics" Data to Identify Transcription Factors Regulating Secondary Metabolism in *Rauvolfia serpentina*. *Plant Molecular Biology Reporter*. 2015. DOI: [10.1007/s11105-015-0919-1](https://doi.org/10.1007/s11105-015-0919-1)

This code was used for Pearson correlation coefficient calculation during the co-expression analysis described in the study.

---

## 📄 License

[GNU General Public License v3.0](LICENSE)


---